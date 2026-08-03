class Ysh < Formula
  desc "Query and update YAML with one portable shell and AWK file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.11.0/ysh", using: :nounzip
  sha256 "7de8eb98d3549e10b5e5b3e508f2f7a7cdf4d0fab851332c98848b4e4361f9b5"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
