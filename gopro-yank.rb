class GoproYank < Formula
  desc "Download and verify every GoPro cloud original"
  homepage "https://github.com/azohra/gopro-yank"
  url "https://github.com/azohra/gopro-yank/releases/download/v1.0.0/gopro-yank_source.tar.gz"
  sha256 "e796a1aaba04ab6c18d91d6016958e7113c7d8cde9e6aaf1f38ef7eb716aff39"
  license "MIT"
  head "https://github.com/azohra/gopro-yank.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gopro-yank"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopro-yank --version")
  end
end
