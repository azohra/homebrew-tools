class Gitrise < Formula
  desc "a lightweight bash tool to trigger builds on Bitrise"
  homepage "https://github.com/azohra/gitrise.sh"
  url "https://github.com/azohra/gitrise.sh/archive/v0.1.0.tar.gz"
  sha256 "d16cfa88e5577e65bbf9ff2971614ef3641bdd10b24f9f5b6d12bd0c0a87eec6"

  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end
  
  test do
    system "#{bin}/gitrise -v"
  end
end  