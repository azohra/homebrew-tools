class Strapped < Formula
  desc "Stay strapped"
  homepage "https://strapped.sh"
  url "https://github.com/azohra/strapped.sh/archive/refs/tags/0.2.0.tar.gz"
  sha256 "ee5f6827592a7374f841c206dbd6198a3bb1572ee5dc1a460bde076857ab0e73"

  def install
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    system "#{bin}/strapped", "-v"
  end
end
