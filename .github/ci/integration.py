"""Plan isolated Kitchen suites, classify changes and pin dependency snapshots."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

# Preserve the existing CI coverage during the grouping trial.
SUITES = {"basic-site", "default", "mod-auth-cas", "php", "module-template",
          "mod-wsgi", "ports", "ssl", "install-override"}
DEPENDENCY = re.compile(r"cookbook '([^']+)', git: '([^']+)', branch: '([^']+)'")


def documentation_only(paths):
    return bool(paths) and all(
        p.lower().endswith(".md") or p.startswith(("docs/", "documentation/"))
        or p in {"LICENSE", "CODE_OF_CONDUCT", "CONTRIBUTING", "TESTING"}
        for p in paths)


def plan(instances):
    groups = {}
    for row in instances:
        name = row["instance"]
        suite = next((s for s in SUITES if name.startswith(s + "-")), None)
        if suite:
            platform = name[len(suite) + 1:]
            groups.setdefault(platform, []).append(name)
    grouped = [{"os": p, "instances": sorted(names)} for p, names in sorted(groups.items())]
    individual = [{"os": g["os"], "instances": [n]} for g in grouped for n in g["instances"]]
    return grouped, individual


def pin(source, manifest):
    def replacement(match):
        name, url, branch = match.groups()
        entry = manifest[name]
        if entry["url"] != url or entry["branch"] != branch:
            raise ValueError("Dependency manifest does not match " + name)
        revision = entry["revision"]
        if not re.fullmatch(r"[0-9a-f]{40}", revision):
            raise ValueError("Invalid Git revision for " + name)
        return f"cookbook '{name}', git: '{url}', ref: '{revision}'"
    if len(DEPENDENCY.findall(source)) != len(manifest):
        raise ValueError("Dependency manifest is incomplete")
    return DEPENDENCY.sub(replacement, source)


def run_instances(instances):
    failures = []
    env = dict(os.environ, MULTIPLE_CONVERGE="2")
    for instance in instances:
        print("::group::Kitchen " + instance, flush=True)
        result = subprocess.run(["kitchen", "test", "^" + re.escape(instance) + "$",
                                 "--destroy=always"], env=env, check=False)
        print("::endgroup::", flush=True)
        if result.returncode:
            failures.append(instance)
    if failures:
        print("::error::Failed instances: " + ", ".join(failures))
    return bool(failures)


def output(values):
    with open(os.environ["GITHUB_OUTPUT"], "a") as stream:
        for key, value in values.items():
            stream.write(key + "=" + (value if isinstance(value, str) else json.dumps(value, separators=(",", ":"))) + "\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["changes", "prepare", "pin", "run"])
    args = parser.parse_args()
    if args.action == "changes":
        base, head = os.environ.get("BASE_SHA", ""), os.environ.get("HEAD_SHA", "HEAD")
        paths = []
        if base and base.strip("0"):
            result = subprocess.run(["git", "diff", "--name-only", "--no-renames", "-z", base, head],
                                    text=True, capture_output=True, check=False)
            if result.returncode == 0:
                paths = [p for p in result.stdout.split("\0") if p]
        output({"integration": "false" if documentation_only(paths) else "true"})
    elif args.action == "prepare":
        instances = json.loads(subprocess.check_output(["kitchen", "list", "--json"], text=True))
        grouped, individual = plan(instances)
        if len(individual) != 148 or len(grouped) != 17:
            raise ValueError("Kitchen coverage changed; review the CI plan before continuing")
        source = Path("Policyfile.rb").read_text()
        manifest = {}
        for name, url, branch in DEPENDENCY.findall(source):
            revision = subprocess.check_output(["git", "ls-remote", "--exit-code", url, "refs/heads/" + branch], text=True).split()[0]
            manifest[name] = dict(url=url, branch=branch, revision=revision)
        digest = hashlib.sha256((source + json.dumps(manifest, sort_keys=True)).encode()).hexdigest()
        output(dict(grouped={"include": grouped},
                    dependencies=manifest, dependency_key=digest))
        print(f"Planned {len(individual)} suites across {len(grouped)} fresh runners")
    elif args.action == "pin":
        path = Path("Policyfile.rb")
        path.write_text(pin(path.read_text(), json.loads(os.environ["DEPENDENCIES"])))
    else:
        return run_instances(json.loads(os.environ["KITCHEN_INSTANCES"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
