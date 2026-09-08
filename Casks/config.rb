cask "config" do
  version "0.19.0"
  sha256 "17a0f12aa0b3916317d5beda25f038f294a81c80a8acbed67783938b9cc80160"

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
