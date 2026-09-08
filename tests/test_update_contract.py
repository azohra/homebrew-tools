import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).parents[1]


class UpdateContractTests(unittest.TestCase):
    def test_local_updates_are_repeatable_without_git_or_pr_writes(self):
        for product in ("gopro-yank", "ysh"):
            with self.subTest(product=product):
                self.check_update(product)

    def test_corrupt_cask_leaves_package_unchanged(self):
        self.check_update("gopro-yank", corrupt=True)

    def check_update(self, product, corrupt=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Casks").mkdir()
            binary = root / "bin"
            binary.mkdir()
            target = root / ("ysh.rb" if product == "ysh" else "Casks/gopro-yank.rb")
            initial = ('class Ysh < Formula\n  url "https://github.com/azohra/yaml.sh/releases/download/v1.0.0/ysh"\n  sha256 "' + '0' * 64 + '"\nend\n' if product == "ysh" else 'cask "gopro-yank" do\n  version "1.0.0"\nend\n')
            target.write_text(initial)
            (binary / "gh").write_text('''#!/bin/sh
set -eu
case "$1 $2" in
  "release view") printf true ;;
  "release download")
    while [ "$1" != --dir ]; do shift; done
    cd "$2"
    printf 'artifact\\n' > ysh
    shasum -a 256 ysh > ysh.sha256
    printf '%s\\n' 'cask "gopro-yank" do' '  version "1.1.0"' '  url "https://github.com/azohra/gopro-yank/releases/download/v#{version}/gopro-yank_darwin_arm64.tar.gz"' 'end' > gopro-yank.rb
    shasum -a 256 gopro-yank.rb > checksums.txt
    [ "$CORRUPT" != 1 ] || printf corrupt >> gopro-yank.rb
    ;;
  *) echo "unexpected GitHub write: $*" >&2; exit 99 ;;
esac
''')
            (binary / "gh").chmod(0o755)
            environment = {**os.environ, "PATH": f"{binary}:{os.environ['PATH']}", "CORRUPT": "1" if corrupt else "0"}
            def update():
                return subprocess.run(["sh", str(ROOT / f"scripts/update-{product}.sh"), "1.1.0"], cwd=root, env=environment, capture_output=True, text=True)
            first = update()
            if corrupt:
                self.assertNotEqual(first.returncode, 0)
                self.assertIn("release bytes do not match", first.stderr)
                self.assertEqual(target.read_text(), initial)
                return
            self.assertEqual(first.returncode, 0, first.stderr)
            updated = target.read_text()
            self.assertIn("1.1.0", updated)
            second = update()
            self.assertEqual(second.returncode, 0, second.stderr)
            self.assertEqual(target.read_text(), updated)
            self.assertFalse((root / ".git").exists())
