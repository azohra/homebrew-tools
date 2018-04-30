class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.1.0/lyra_darwin_amd64_v1.1.0.tar.gz"
  sha256 "fbd8de5a80697b2f9776df80220f726e43d38a66e4a2b25a02e2d2e9ce1ab8e6"

  bottle :unneeded

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "-h"
  end
end
