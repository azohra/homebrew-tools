class Strapped < Formula
  desc "Stay strapped"
  homepage "https://strapped.azohra.com"
  url "https://github.com/azohra/strapped.sh/archive/refs/tags/0.3.0.tar.gz"
  sha256 "e8c7a1dde8bed3c37d9e4ea9e894436b4c983947edbad8c72648ef0364156f9c"

  def install
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    system "#{bin}/strapped", "-v"
  end
end
