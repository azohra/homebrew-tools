class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.1.0/lyra_darwin_amd64_v1.1.0.tar.gz"
  sha256 "20f7abeb59d888f825a432efb9a83ec7af1e25f59a744db35781dbdc4bbce6fe"

  bottle :unneeded

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "-h"
  end
end
