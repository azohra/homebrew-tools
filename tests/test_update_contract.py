import os
from pathlib import Path
import subprocess
import shutil
import tempfile
import unittest


ROOT = Path(__file__).parents[1]


class UpdateContractTests(unittest.TestCase):
    def test_dispatch_helper_passes_automation_ref_to_gh(self):
        with tempfile.TemporaryDirectory() as directory:
            fake_bin = Path(directory) / "bin"
            fake_bin.mkdir()
            arguments = Path(directory) / "arguments"
            (fake_bin / "gh").write_text(
                "#!/bin/sh\nprintf '%s\\n' \"$@\" > \"$DISPATCH_ARGS\"\n",
                encoding="utf-8",
            )
            (fake_bin / "gh").chmod(0o755)
            environment = {
                **os.environ,
                "PATH": f"{fake_bin}:{os.environ['PATH']}",
                "DISPATCH_ARGS": str(arguments),
            }

            result = subprocess.run(
                ["sh", "scripts/dispatch-check.sh", "automation/orca"],
                cwd=ROOT,
                env=environment,
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(
                arguments.read_text(encoding="utf-8").splitlines(),
                [
                    "workflow",
                    "run",
                    "check.yml",
                    "--ref",
                    "automation/orca",
                    "--repo",
                    "azohra/homebrew-tools",
                ],
            )

    def test_dispatch_helper_rejects_non_automation_ref(self):
        with tempfile.TemporaryDirectory() as directory:
            arguments = Path(directory) / "arguments"
            environment = {**os.environ, "DISPATCH_ARGS": str(arguments)}
            result = subprocess.run(
                ["sh", "scripts/dispatch-check.sh", "main"],
                cwd=ROOT,
                env=environment,
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(result.returncode, 2)
            self.assertIn("unexpected branch", result.stderr)
            self.assertFalse(arguments.exists())

    def test_dispatch_helper_preserves_gh_failure_for_scheduled_retry(self):
        with tempfile.TemporaryDirectory() as directory:
            fake_bin = Path(directory) / "bin"
            fake_bin.mkdir()
            (fake_bin / "gh").write_text("#!/bin/sh\nexit 7\n", encoding="utf-8")
            (fake_bin / "gh").chmod(0o755)
            environment = {
                **os.environ,
                "PATH": f"{fake_bin}:{os.environ['PATH']}",
            }
            result = subprocess.run(
                ["sh", "scripts/dispatch-check.sh", "automation/orca"],
                cwd=ROOT,
                env=environment,
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(result.returncode, 7)

    def test_gopro_updater_retries_dispatch_without_second_push(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            remote = Path(directory) / "remote.git"
            fake_bin = Path(directory) / "bin"
            state = Path(directory) / "gh-state"
            calls = Path(directory) / "gh-calls"
            subprocess.run(["git", "init", "--bare", str(remote)], check=True,
                            capture_output=True, text=True)
            (root / "Casks").mkdir(parents=True)
            (root / "scripts").mkdir()
            shutil.copy(ROOT / "scripts/update-gopro-yank.sh", root / "scripts")
            shutil.copy(ROOT / "scripts/dispatch-check.sh", root / "scripts")
            (root / "Casks/gopro-yank.rb").write_text(
                'cask "gopro-yank" do\n  version "1.0.0"\nend\n',
                encoding="utf-8",
            )
            for command in (
                ["git", "init", str(root)],
                ["git", "-C", str(root), "config", "user.name", "test"],
                ["git", "-C", str(root), "config", "user.email", "test@example.com"],
            ):
                subprocess.run(command, check=True, capture_output=True, text=True)
            subprocess.run(["git", "-C", str(root), "add", "."], check=True,
                            capture_output=True, text=True)
            subprocess.run(
                ["git", "-C", str(root), "commit", "-m", "initial"],
                check=True,
                capture_output=True,
                text=True,
            )
            subprocess.run(["git", "-C", str(root), "branch", "-M", "main"], check=True,
                            capture_output=True, text=True)
            subprocess.run(["git", "-C", str(root), "remote", "add", "origin", str(remote)],
                            check=True, capture_output=True, text=True)
            subprocess.run(["git", "-C", str(root), "push", "-u", "origin", "main"],
                            check=True, capture_output=True, text=True)

            fake_bin.mkdir()
            (fake_bin / "gh").write_text(
                """#!/bin/sh
set -eu
printf '%s\\n' "$*" >> "$GH_CALLS"
case "$1 $2" in
  "release download")
    while [ "$#" -gt 0 ]; do
      if [ "$1" = "--dir" ]; then
        shift
    printf '%s\\n' 'cask "gopro-yank" do' '  version "1.1.0"' '  url "https://example.test/releases/download/v#{version}/gopro-yank.zip"' 'end' > "$1/gopro-yank.rb"
      fi
      shift
    done
    ;;
  "pr list") ;;
  "pr create") ;;
  "workflow run")
    count=0
    [ -f "$GH_STATE" ] && count=$(cat "$GH_STATE")
    count=$((count + 1))
    printf '%s\\n' "$count" > "$GH_STATE"
    [ "$count" -gt 1 ] || exit 17
    ;;
  *) exit 99 ;;
esac
""",
                encoding="utf-8",
            )
            (fake_bin / "gh").chmod(0o755)
            environment = {
                **os.environ,
                "PATH": f"{fake_bin}:{os.environ['PATH']}",
                "GH_CALLS": str(calls),
                "GH_STATE": str(state),
            }

            first = subprocess.run(
                ["sh", "scripts/update-gopro-yank.sh", "1.1.0"],
                cwd=root,
                env=environment,
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(first.returncode, 17, first.stderr)
            branch = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "refs/remotes/origin/automation/gopro-yank"],
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            subprocess.run(["git", "-C", str(root), "switch", "main"], check=True,
                            capture_output=True, text=True)

            second = subprocess.run(
                ["sh", "scripts/update-gopro-yank.sh", "1.1.0"],
                cwd=root,
                env=environment,
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(second.returncode, 0, second.stderr)
            after = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "refs/remotes/origin/automation/gopro-yank"],
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            self.assertEqual(after, branch)
            self.assertEqual(state.read_text(encoding="utf-8").strip(), "2")
            self.assertEqual(
                sum("workflow run" in line for line in calls.read_text(encoding="utf-8").splitlines()),
                2,
            )


if __name__ == "__main__":
    unittest.main()
