cask "orca" do
  arch arm: "arm64", intel: "x64"

  version "1.4.194"
  sha256 arm:   "684e9241dd9e11db842b366b66c4dd463d8e588995fb51597c2974804513c768",
         intel: "aa18611aeda637da66c04a4c72254a9cf7f1935a0505f849840120e5972f21c6"

  url "https://github.com/stablyai/orca/releases/download/v#{version}/orca-macos-#{arch}.dmg",
      verified: "github.com/stablyai/orca/"
  name "Orca"
  desc "IDE for orchestrating AI coding agents across terminals and worktrees"
  homepage "https://onorca.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself in place through its built-in updater, so brew
  # (and mise) install once and stay out of the way.
  auto_updates true
  conflicts_with cask: "orca@rc"
  depends_on macos: :big_sur

  app "Orca.app"
  # The bundled CLI, linked onto PATH at install time so shells can reach it
  # without the in-app "Install CLI" action.
  binary "#{appdir}/Orca.app/Contents/Resources/bin/orca"

  zap trash: [
    "~/.orca",
    "~/Library/Application Support/Orca",
    "~/Library/Caches/com.stablyai.orca",
    "~/Library/Caches/com.stablyai.orca.ShipIt",
    "~/Library/HTTPStorages/com.stablyai.orca",
    "~/Library/Preferences/com.stablyai.orca.plist",
    "~/Library/Saved Application State/com.stablyai.orca.savedState",
  ]
end
