class Ysh < Formula
  desc "Query, transform, and carefully edit YAML in one shell file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.18.1/ysh", using: :nounzip
  sha256 "2c486cc7ba37f94cd91694774ff88abd2fc21cafea7fd0ad962a5bd3941e8bcb"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
