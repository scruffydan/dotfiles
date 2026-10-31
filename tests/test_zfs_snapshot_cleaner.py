"""Run the cleaner with isolated mocks; never invoke real ZFS or sleep."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


SCRIPT = (Path(__file__).resolve().parents[1]
          / "scripts/Dangerous_Scripts/zfs_snapshot_cleaner.sh")
SNAPSHOTS = [
    "tank@root",
    "tank/data@daily",
    "tank/data/child@daily",
    "tank/data/child/grandchild@daily",
    "tank/database@keep",
    "tank/sibling@keep",
    "other/data@keep",
    "Tank-2.backup_1:copy@daily",
    "tank/data-1.name_2:archive@daily",
    "tank/-r@daily",
    "tank/space name@daily",
]
DATASETS = sorted({snap.split("@")[0] for snap in SNAPSHOTS}
                  | {"other", "tank/empty"})

# Model option parsing, including the dangerous no-operand global listing.
# Destruction only records argv and never calls another command.
MOCK = r'''
import getopt
import json
import os
from pathlib import Path
import sys

command = Path(sys.argv[0]).name
args = sys.argv[1:]
with open(os.environ["MOCK_LOG"], "a") as log:
    log.write(json.dumps([command, *args]) + "\n")
if command == "sleep":
    sys.exit(0)
if args and args[0] == "destroy":
    sys.exit(0)
if not args or args[0] != "list":
    sys.exit(2)
try:
    options, targets = getopt.getopt(args[1:], "Ho:t:r")
except getopt.GetoptError:
    sys.exit(2)
options = dict(options)
datasets = json.loads(os.environ["MOCK_DATASETS"])
if any(target not in datasets for target in targets):
    sys.exit(1)
rows = (json.loads(os.environ["MOCK_SNAPSHOTS"])
        if options.get("-t") == "snapshot" else datasets)
for row in rows:
    dataset = row.split("@")[0]
    if not targets or any(dataset == target or
                          ("-r" in options and dataset.startswith(target + "/"))
                          for target in targets):
        print(row)
'''


class CleanerTests(unittest.TestCase):
    shell = shutil.which("sh")

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="zfs cleaner test ")
        self.addCleanup(self.temp.cleanup)
        root = Path(self.temp.name)
        self.bin = root / "bin"
        self.bin.mkdir()
        self.log = root / "calls.jsonl"
        for command in ("zfs", "sleep"):
            mock = self.bin / command
            mock.write_text(f"#!{sys.executable}\n" + MOCK)
            mock.chmod(0o755)
        # No system directories on PATH: ZFS and sleep can only be our mocks.
        for command in ("basename", "wc", "tr"):
            executable = shutil.which(command)
            self.assertIsNotNone(executable, command)
            (self.bin / command).symlink_to(executable)
        self.assertIsNotNone(self.shell)
        self.env = dict(
            os.environ, PATH=str(self.bin), LC_ALL="C",
            MOCK_LOG=str(self.log), MOCK_DATASETS=json.dumps(DATASETS),
            MOCK_SNAPSHOTS=json.dumps(SNAPSHOTS),
        )

    def clean(self, *targets, answer="YES\n"):
        self.log.write_text("")
        result = subprocess.run(
            [self.shell, str(SCRIPT), *targets], input=answer,
            text=True, capture_output=True, env=self.env, timeout=10,
        )
        calls = [json.loads(line) for line in self.log.read_text().splitlines()]
        return result, calls

    def test_invalid_targets_never_invoke_zfs_even_after_yes(self):
        for target in (
            "", "-", "--", "-r", "-H", "-Hr", "--help", "-o", "-d1",
            "1tank", "_tank", ".tank", ":tank", "/tank", "tank/",
            "tank//data", "tank/data//child", ".", "..", "tank/.",
            "tank/..", "tank/./data", "tank/../data", "tank/data/../child",
            "tank/data@snap", "tank/data#bookmark", "tank,data", "tank/*",
            "tank;other", "tank\tdata", "tank\ndata", "tank/é",
        ):
            with self.subTest(target=target):
                result, calls = self.clean(target)
                self.assertNotEqual(result.returncode, 0, result.stdout)
                self.assertEqual(calls, [])

    def test_exactly_one_explicit_target_is_required(self):
        for targets in ((), ("tank/data", "other"), ("tank/data", "-r")):
            with self.subTest(targets=targets):
                result, calls = self.clean(*targets)
                self.assertNotEqual(result.returncode, 0, result.stdout)
                self.assertEqual(calls, [])

    def test_valid_targets_keep_recursive_deletion_scoped(self):
        for target in ("tank", "tank/data", "Tank-2.backup_1:copy",
                       "tank/data-1.name_2:archive", "tank/-r", "tank/space name"):
            with self.subTest(target=target):
                result, calls = self.clean(target)
                self.assertEqual(result.returncode, 0, result.stderr)
                expected = [snap for snap in SNAPSHOTS
                            if snap.split("@")[0] == target
                            or snap.startswith(target + "/")]
                listing = ["zfs", "list", "-H", "-o", "name", "-t", "snapshot",
                           "-r", "--", target]
                self.assertEqual(calls, [
                    ["zfs", "list", "-H", "--", target], listing,
                    ["sleep", "10"], listing,
                    *[["zfs", "destroy", "-v", "--", snap] for snap in expected],
                ])
                self.assertIn(f"Snapshots found (recursive): {len(expected)}",
                              result.stdout)

    def test_nonexistent_target_stops_before_snapshot_listing(self):
        result, calls = self.clean("tank/missing")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(calls, [["zfs", "list", "-H", "--", "tank/missing"]])

    def test_declining_confirmation_never_deletes(self):
        for answer in ("NO\n", "yes\n", "", "YES extra\n"):
            with self.subTest(answer=answer):
                result, calls = self.clean("tank/data", answer=answer)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(len(calls), 2)
                self.assertTrue(all(call[:2] == ["zfs", "list"] for call in calls))

    def test_empty_target_dataset_never_deletes(self):
        result, calls = self.clean("tank/empty")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("Snapshots found (recursive): 0", result.stdout)
        self.assertFalse(any(call[:2] == ["zfs", "destroy"] for call in calls))


if __name__ == "__main__":
    unittest.main()
