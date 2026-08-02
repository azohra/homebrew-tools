cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.2.0"
  sha256 arm:          "0d6c664db869f8142c08a262a746a22961ddcbaaec239d3e272086141475cfbe",
         intel:        "eba5d52d41f1b1e57875e5286922e82ca12800388fc3b642892007f03510ad4b",
         arm64_linux:  "96a9c0f3c7c7ea03e901b9919469a2c1105248bcb9ede70dac87cc58d16d1e94",
         x86_64_linux: "b72966d203764557f564952584f6a1ff7a718d7fd5c13fe4e783b8d7cccc517b"

  on_macos do
    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", "#{staged_path}/gopro-yank"]
    end
  end

  url "https://github.com/azohra/gopro-yank/releases/download/v#{version}/gopro-yank_#{os}_#{arch}.tar.gz"
  name "GoPro Yank"
  desc "Download and verify every GoPro cloud original"
  homepage "https://github.com/azohra/gopro-yank"

  binary "gopro-yank"
end
