class Gitrise < Formula
  desc "a lightweight bash tool to trigger builds on Bitrise"
  homepage "https://github.com/azohra/gitrise.sh"
  url "https://github.com/azohra/gitrise.sh/archive/v0.1.0.tar.gz"
  sha256 "3d494d5541527a56972e9f2bd195dbcb89659a35d0bf198972c0cc55de9ffaec"

  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end
  
  test do
    system "#{bin}/gitrise -v"
  end
end  