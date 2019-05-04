# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Strapped < Formula
  desc "Stay strapped"
  homepage "https://strapped.sh"
  url "https://github.com/azohra/strapped.sh/archive/0.1.3.tar.gz"
  sha256 "c2f0144cc9b03fff8b71776b60d45efd503f29e2a18c2c54ac57e48275faa3fe"

  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end

  test do
    system "#{bin}/ysh -v"
  end
end
