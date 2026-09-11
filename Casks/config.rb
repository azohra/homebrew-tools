cask "config" do
  version "0.22.0"
  sha256 "ad22b7d0fa75ae0b2eb7bb1e089db91e277a9155eb1f7d66a96c06332f5627e0"

  url "https://github.com/azohra/config/releases/download/v#{version}/config_darwin_arm64.tar.gz"
  name "Config"
  desc "Converge machine configuration from a Git repository"
  homepage "https://github.com/azohra/config"

  depends_on :macos
  depends_on arch: :arm64

  binary "config"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-d", "com.apple.quarantine", "#{staged_path}/config"]
  end
end
