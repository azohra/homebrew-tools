cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.1.0"
  sha256 arm:          "f3bdff26b5cdf329bf5c30aa1d6cccbb1736697372af5876aff1910e4271bac4",
         intel:        "5de123b0b3e7fb2f2054383b17c1dabdff0bc30c64341ef691b4475544471b9a",
         arm64_linux:  "badb7ecc319e7054bd996eac651596bf48ce5dbb08fbb5930a76c167cde42f61",
         x86_64_linux: "64a5978784992e2f6154fef5ea5afd09b9697a1ea99048f10033ef6cf53601ff"

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
