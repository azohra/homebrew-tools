cask "orca" do
  arch arm: "arm64", intel: "x64"

  version "1.4.193"
  sha256 arm:   "3182fd94438cf905c10eab53364ab6bf848242ad073075fef0134d594e85d68c",
         intel: "adc51cdc64716dd164b11f1ee155907502907efcfb95b7052e6a645119b7440e"

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
