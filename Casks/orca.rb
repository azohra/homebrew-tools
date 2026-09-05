cask "orca" do
  arch arm: "arm64", intel: "x64"

  version "1.4.197"
  sha256 arm:   "df350da3be8e1a85b522347cdc15c234cdcdfe063f150c7f3c791e1bd064139d",
         intel: "f5cd68e986bde700a73cb9dccf97d3ca62ea9fd8ad9b9ed313dc3d2b0ec781b8"

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
