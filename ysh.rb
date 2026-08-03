class Ysh < Formula
  desc "Query, transform, and carefully edit YAML in one shell file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.17.0/ysh", using: :nounzip
  sha256 "c6811dd9a9751c2f21e3cd09ea836ddb30464eabe6a192c288fef729b54165b9"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
