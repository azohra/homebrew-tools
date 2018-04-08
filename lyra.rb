class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.0.0/lyra-darwin"
  sha256 "86a2815cc5a7021f3d1a1399be372bca0531010358363bd7822732e43417c847"

  bottle :unneeded

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "-h"
  end
end
