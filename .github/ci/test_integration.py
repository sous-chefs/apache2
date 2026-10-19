import io
import unittest
from unittest.mock import patch
import integration


class IntegrationTest(unittest.TestCase):
    def test_docs_filter_is_conservative(self):
        self.assertTrue(integration.documentation_only(["README.md", "documentation/example.md"]))
        for paths in ([], ["resources/module.rb"], ["README.md", "Policyfile.rb"], [".github/workflows/ci.yml"]):
            self.assertFalse(integration.documentation_only(paths))

    def test_grouping_preserves_exact_instance_set_and_exclusions(self):
        names = ["default-ubuntu-2404", "php-ubuntu-2404", "default-almalinux-10", "custom-template-ubuntu-2404"]
        grouped, individual = integration.plan([{"instance": n} for n in names])
        self.assertEqual(len(grouped), 2)
        self.assertEqual(sorted(n for g in grouped for n in g["instances"]), sorted(r["instances"][0] for r in individual))
        self.assertNotIn("custom-template-ubuntu-2404", [r["instances"][0] for r in individual])
        self.assertNotIn("mod-auth-cas-almalinux-10", [r["instances"][0] for r in individual])

    def test_pin_requires_matching_snapshot(self):
        source = "cookbook 'apt', git: 'https://example/apt.git', branch: 'main'\n"
        manifest = {"apt": dict(url="https://example/apt.git", branch="main", revision="a" * 40)}
        self.assertIn("ref: '" + "a" * 40 + "'", integration.pin(source, manifest))
        with self.assertRaises(ValueError):
            integration.pin(source, {})

    @patch("integration.subprocess.run")
    @patch("sys.stdout", new_callable=io.StringIO)
    def test_each_suite_gets_its_own_lifecycle_even_after_failure(self, stdout, run):
        run.return_value.returncode = 1
        self.assertTrue(integration.run_instances(["default-ubuntu-2404", "php-ubuntu-2404"]))
        self.assertEqual(run.call_count, 2)
        for call in run.call_args_list:
            self.assertEqual(call.args[0][-1], "--destroy=always")
            self.assertEqual(call.kwargs["env"]["MULTIPLE_CONVERGE"], "2")


if __name__ == "__main__":
    unittest.main()
