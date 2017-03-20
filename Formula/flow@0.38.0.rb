class FlowAT0380 < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.38.0.tar.gz"
  version "0.38.0"
  sha256 "f21b56e10c1bddfe3d59da872e50d4013672a41f11a5d25d9dd67e494e8f1ae7"
  head "https://github.com/facebook/flow.git"

  bottle do
    root_url "https://raw.githubusercontent.com/ryanhomer/homebrew-flow/master/bottles"
    cellar :any_skip_relocation
    sha256 "21e85458345db008bf86ba0b74dbbf7f326b39bc8336965b5d5033309234a982" => :sierra
    sha256 "7036d0f132b171b75f92dfe0bfb6839216bf385b7611c3dabd84d9f1c998b700" => :el_capitan
    sha256 "428e13e4bd9512fea3538cc9593f12780fd50d2ce77f7df4c60a0c4a0ade6204" => :yosemite
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
