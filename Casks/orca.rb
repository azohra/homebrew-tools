cask "orca" do
  arch arm: "arm64", intel: "x64"

  version "1.4.245"
  sha256 arm:   "a413b65998926b0a4654d6b7e0c0f789a5f758ad3a777a3dec60c8de722bbad8",
         intel: "b21b392f15be0c38ee9db7361c1d726db047bc779b9d57718a0e74739cff173f"

  url "https://github.com/stablyai/orca/releases/download/v#{version}/orca-macos-#{arch}.dmg"
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
