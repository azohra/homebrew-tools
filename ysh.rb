class Ysh < Formula
  desc "Query, transform, and carefully edit YAML in one shell file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.19.1/ysh", using: :nounzip
  sha256 "35c8cc8bd36f35f3dab145ad20389861700fccc3f23b2a9265f2078f9cd5f7a4"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
