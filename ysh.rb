class Ysh < Formula
  desc "a lightweight yaml parser written in bash for bash"
  homepage "https://yaml.sh"
  url "https://github.com/azohra/yaml.sh/archive/v0.1.5.tar.gz"
  sha256 "3f511c7f2760f7c82aee1c4b3df3869540a3e067a5b23d35b2fa567b76603391"

  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end

  test do
    system "#{bin}/ysh -v"
  end
end
