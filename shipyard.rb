class Shipyard < Formula
  desc "Manage opinionated soft multitenancy for GKE"
  homepage "https://shipyard.azohra.com/"
  url "https://github.com/azohra/shipyard/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "9259b0a6b279dccdb9eacfcb850ec7f5dc28251c2aa49e66d7920933d0542574"

  def install
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    system "#{bin}/shipyard", "-v"
  end
end
