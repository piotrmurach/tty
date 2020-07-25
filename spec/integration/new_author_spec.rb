# frozen_string_literal: true

RSpec.describe "`teletype new --author` command", type: :sandbox do
  it "sets an author" do
    app_name = "newcli"
    command = "teletype new #{app_name} --author 'Author A'"
    `#{command}`

    license = ::File.binread("newcli/LICENSE.txt")
    expect(license).to include("Author A")
  end

  it "sets multiple authors" do
    app_name = "newcli"
    command = "teletype new #{app_name} --author 'Author A' 'Author B'"
    `#{command}`

    license = ::File.binread("newcli/LICENSE.txt")
    expect(license).to include("Author A, Author B")
  end
end
