class Ysh < Formula
  desc "Query, transform, and carefully edit YAML in one shell file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.18.0/ysh", using: :nounzip
  sha256 "4ec74b5b1a5b96e5b60b5bcd3f44ad401e420a8b4662f54fc623fa9787f16dd3"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
