class Ysh < Formula
  desc "Query and update YAML with one portable shell and AWK file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.12.0/ysh", using: :nounzip
  sha256 "642da15775bae7f797032abbc9d4e5a21de7657e4a76de6897d19d1354e53afe"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
