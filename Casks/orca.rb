cask "orca" do
  arch arm: "arm64", intel: "x64"

  version "1.4.251"
  sha256 arm:   "2588fb3eea34eb0d328b9a5cd3be5ab5b36aafb02622d01308e2cb3535d8e0fe",
         intel: "6d9b6a0ce76a11887cec53183cdf66300f51d41a58a52d5cca279a2d7fc50d65"

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
