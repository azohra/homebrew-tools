class Ysh < Formula
  desc "Query and update YAML with one portable shell and AWK file"
  homepage "https://yaml.azohra.com"
  url "https://github.com/azohra/yaml.sh/releases/download/v1.14.0/ysh", using: :nounzip
  sha256 "a2054a34d2ec4748f04ef4413416892db099eabe99fbcb2418e7dc6f3a7fb3db"
  license "MIT"

  def install
    bin.install "ysh"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ysh --version").strip
    assert_equal "yaml.sh\n", pipe_output("#{bin}/ysh -r '.name'", "name: yaml.sh\n")
  end
end
