class Ysh < Formula
  desc "Query, transform, and carefully edit YAML in one shell file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.17.1/ysh", using: :nounzip
  sha256 "2ab5e236dc54e21fb5ecdd4abe6eb92782a409a27c7c873f9111690d3067fcc0"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
