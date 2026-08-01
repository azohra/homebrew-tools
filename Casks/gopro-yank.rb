cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.0.1"
  sha256 arm:          "b5aa07762468d106054cfda7aad43236c6c87c0e13b75b72ee2df938de8bd954",
         intel:        "5e810473f9c2a511a6943adfa1562931e3ce7f03201bec431417ba8f4f4bd9fb",
         arm64_linux:  "6c08038253a64cfee9d96466f67b30c5632b970110d51ffbf7c6b95d4d539e89",
         x86_64_linux: "fb1f625ab40960e9d9f3a25930dbffcc3b668fc7ed7edfcd415e33193ebf8355"

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
