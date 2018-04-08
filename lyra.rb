class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.0.0/lyra-darwin-1.0.0.tar.gz"
  sha256 "6d55958eab6cd66ef6682de4ad3306cde80fc357b4b6e690e784415d6ac985f2"

  bottle :unneeded

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "-h"
  end
end
