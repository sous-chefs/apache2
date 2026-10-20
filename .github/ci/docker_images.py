"""Compare registry pulls with restored Docker archives on fresh runners."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import statistics
import subprocess
import time


def docker(*args):
    return subprocess.check_output(["docker", *args], text=True).strip()


def inspect(tag):
    return json.loads(docker("image", "inspect", tag))[0]


def validate(images):
    for image in images:
        if inspect(image["tag"])["Id"] != image["id"]:
            raise ValueError("Wrong image loaded: " + image["tag"])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["seed", "start", "pull", "load", "report"])
    args = parser.parse_args()
    root = Path(os.environ.get("RUNNER_TEMP", "/tmp"))
    archive = root / "dokken-images.tar"
    manifest = root / "images.json"
    clock = root / "image-start.txt"
    if args.action == "seed":
        tags = ["cincproject/cinc:latest", os.environ["PLATFORM_IMAGE"] + ":latest"]
        images = []
        started = time.monotonic()
        for tag in tags:
            docker("pull", "--platform", "linux/amd64", tag)
            row = inspect(tag)
            images.append(dict(tag=tag, ref=row["RepoDigests"][0], id=row["Id"]))
        pull_seconds = time.monotonic() - started
        started = time.monotonic()
        docker("save", "--output", str(archive), *tags)
        manifest.write_text(json.dumps(images))
        key = "dokken-images-v1-Linux-X64-" + hashlib.sha256(json.dumps(images, sort_keys=True).encode()).hexdigest()
        with open(os.environ["GITHUB_OUTPUT"], "a") as output:
            output.write("key=" + key + "\n")
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as output:
            output.write(f"Seed {tags[1]}: pull {pull_seconds:.2f}s; docker save {time.monotonic()-started:.2f}s; archive {archive.stat().st_size/1024**2:.1f} MiB.\n")
    elif args.action == "start":
        # Called before actions/cache, so restore includes download and extraction.
        images = json.loads(manifest.read_text())
        for image in images:
            result = subprocess.run(["docker", "image", "inspect", image["tag"]], capture_output=True)
            if result.returncode == 0:
                raise ValueError("Benchmark runner already contains " + image["tag"])
        clock.write_text(str(time.monotonic()))
    elif args.action in {"pull", "load"}:
        images = json.loads(manifest.read_text())
        if args.action == "pull":
            for image in images:
                docker("pull", "--platform", "linux/amd64", image["ref"])
                docker("tag", image["ref"], image["tag"])
        else:
            docker("load", "--input", str(archive))
        validate(images)
        result = dict(os=os.environ["PLATFORM"], mode=args.action,
                      trial=int(os.environ["TRIAL"]),
                      seconds=time.monotonic()-float(clock.read_text()),
                      images=images)
        Path(f"result-{result['os']}-{result['mode']}-{result['trial']}.json").write_text(json.dumps(result))
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as output:
            output.write(f"{result['os']} {result['mode']} trial {result['trial']}: **{result['seconds']:.2f}s**, both image IDs verified.\n")
    else:
        rows = [json.loads(p.read_text()) for p in Path("results").glob("result-*.json")]
        if len(rows) != 18:
            raise ValueError(f"Expected 18 measurements, got {len(rows)}")
        lines = ["| OS | Registry pull median (range) | Cache restore + load median (range) |", "| --- | ---: | ---: |"]
        for platform in sorted({r['os'] for r in rows}):
            columns = []
            snapshots = {json.dumps(r['images'], sort_keys=True) for r in rows if r['os']==platform}
            if len(snapshots) != 1:
                raise ValueError("Benchmark image snapshots differ")
            for mode in ("pull", "load"):
                values = [r['seconds'] for r in rows if r['os']==platform and r['mode']==mode]
                if len(values) != 3:
                    raise ValueError("Missing repeats")
                columns.append(f"{statistics.median(values):.2f}s ({min(values):.2f}–{max(values):.2f}s)")
            lines.append("| " + " | ".join([platform, *columns]) + " |")
        lines.append("\nCache timing includes Actions download/decompression and docker load. Pull timing includes digest pulls and tagging. Checkout, manifest download and runner queue/setup are excluded from both. Cache creation is reported separately by seed jobs; it is not free. No containers or runner state are reused.")
        report = "\n".join(lines) + "\n"
        print(report)
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as output:
            output.write(report)


if __name__ == "__main__":
    main()
