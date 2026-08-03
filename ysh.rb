class Ysh < Formula
  desc "Query and update YAML with one portable shell and AWK file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.15.0/ysh", using: :nounzip
  sha256 "844ba6114628b0a4e4c35b62e61f7f280bdbeb5ca2424dbc8c909cc841575918"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
