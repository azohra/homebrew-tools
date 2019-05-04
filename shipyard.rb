# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Shipyard < Formula
  desc ""
  homepage ""
  url "https://github.com/azohra/shipyard/archive/v0.0.2.tar.gz"
  sha256 "9259b0a6b279dccdb9eacfcb850ec7f5dc28251c2aa49e66d7920933d0542574"
  
  bottle :unneeded

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}/bin"
  end

  test do
    system "#{bin}/shipyard -v"
  end
end

