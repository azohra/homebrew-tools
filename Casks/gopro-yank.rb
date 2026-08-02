cask "gopro-yank" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.3.0"
  sha256 arm:          "2b1fe8b45b42ff493d759d1cf167b9993b6ef5cd49b712c72bdd4897678e74c5",
         intel:        "6472806c8f2d7b2bbbd70427540154ea6c39fccfc88009c157fba9dc07bb7ffb",
         arm64_linux:  "bf36d84b2f87dc85068040e1baaf2d23fa657c75a6634ea506e54536cddd8984",
         x86_64_linux: "ec0628e7fdf6cfd7b64e40cbb7b7683d7c8c8d1db38ba4e6cb35a7a965ba8c01"

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
