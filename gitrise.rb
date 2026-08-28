class Gitrise < Formula
  desc "Trigger Bitrise builds from the command-line"
  homepage "https://github.com/Tumiya/gitrise"
  url "https://github.com/Tumiya/gitrise/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0cb39161f02ed56cfbf2e8275cfa2d8eb05467f004f61134525e323378776134"

  def install
    bin.install "gitrise.sh"
  end

  test do
    system "#{bin}/gitrise.sh", "-v"
  end
end
