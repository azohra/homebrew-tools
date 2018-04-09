class Lyra < Formula
  desc "a lightweight encryption tool that makes protecting your sensitive files easy"
  homepage "https://github.com/azohra/lyra"
  url "https://github.com/azohra/lyra/releases/download/v1.0.1/lyra_darwin_amd64_v1.0.1.tar.gz"
  sha256 "e01c812d8e48bee838bdf3997a663f711a47b55d19eb685cb369cc9803b5c743"

  bottle :unneeded

  def install
    bin.install "lyra"
  end

  test do
    system "#{bin}/lyra", "-h"
  end
end
