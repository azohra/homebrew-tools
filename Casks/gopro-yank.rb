cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.3.1"
  sha256 arm:          "489507326a9ce3c66838a4bd7c8ce8e44e7f020b67c41a8b3db6bb7907789df3",
         intel:        "cb3194da3f91d9182cd1a5fe593e79ee59c82f6fc950ff02e7f3d6ff03e913f8",
         arm64_linux:  "677eace76af8d940a5ebd339d288207324835bdcdf84c61449890ac87c530329",
         x86_64_linux: "1d001671b21212d353b11550e8131977d7b1d0f4fd86616f721ee05e1b6e6f25"

  on_macos do
    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", "#{staged_path}/gopro-yank"]
    end
  end

  url "https://github.com/azohra/gopro-yank/releases/download/v#{version}/gopro-yank_#{os}_#{arch}.tar.gz"
  name "GoPro Yank"
  desc "Download and verify available GoPro cloud originals"
  homepage "https://gopro-yank.azohra.com/"

  binary "gopro-yank"
end
