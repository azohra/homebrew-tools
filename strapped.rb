# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Strapped < Formula
  desc "Stay strapped"
  homepage "https://strapped.sh"
  url "https://github.com/azohra/strapped.sh/archive/0.2.0.tar.gz"
  sha256 "ee5f6827592a7374f841c206dbd6198a3bb1572ee5dc1a460bde076857ab0e73"

  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end

  test do
    system "#{bin}/ysh -v"
  end
end
