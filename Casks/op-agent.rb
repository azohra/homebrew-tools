cask "op-agent" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.1.3"
  sha256 arm:          "ac9da39dfc68e0c244cc906c2f876d54ea46c6e0f6dab3df21a1329ec78b9616",
         arm64_linux:  "372027181626e876fcc18b8ae42ce70735b56b667f3c98e6788837b85eeba3c9",
         x86_64_linux: "e7914f8809a93c26bf33a5d876664f31c50f992a8645753c5909b404a774ac82"

  on_macos do
    depends_on arch: :arm64

    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", "#{staged_path}/op-agent"]
    end
  end

  url "https://github.com/azohra/op-agent/releases/download/v#{version}/op-agent_#{version}_#{os}_#{arch}.tar.gz"
  name "op-agent"
  desc "Resolve and cache 1Password secrets for command-line tasks"
  homepage "https://github.com/azohra/op-agent"

  depends_on cask: "1password-cli"

  binary "op-agent"
end
