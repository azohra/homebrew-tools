cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "2.0.0"
  sha256 arm:          "e8dc3ef87317576546e46c928316cfcfa9671a05dec9c2d14eb04c093c49a3fe",
         arm64_linux:  "665d585680d9481ce15ee3e4200b6763b7f0f0e82fed79b965af200f07e008e1",
         x86_64_linux: "06ea90da3eb4ac6a985b13a3f87e56ff9c890b8f6cc2d1f5102a0af94e834740"

  on_macos do
    depends_on arch: :arm64

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
