class Lyra < Formula
  desc "Encrypt sensitive files from the command-line"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.1.0/lyra_darwin_amd64_v1.1.0.tar.gz"
  sha256 "20f7abeb59d888f825a432efb9a83ec7af1e25f59a744db35781dbdc4bbce6fe"

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "--version"
  end
end
