class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.0.0/lyra-darwin"
  sha256 "f0f2ff1995a53579fe188c5e70a1a649926b5bca7026160f619e9d37b35f4a5f"

  bottle :unneeded

  def install
    bin.install "lyra-darwin"
  end

  test do
    system "#{bin}/lyra-darwin", "-h"
  end
end
