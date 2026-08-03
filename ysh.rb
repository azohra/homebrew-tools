class Ysh < Formula
  desc "Query and update YAML with one portable shell and AWK file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.10.0/ysh", using: :nounzip
  sha256 "fcd4f566464077ecdac038583b5550c9eadf89e9ea859208b7bd6a6237d32016"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
