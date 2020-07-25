# frozen_string_literal: true

RSpec.describe "teletype new --test", type: :sandbox do
  it "generates a rspec test setup" do
    command = "teletype new newcli --test rspec"
    `#{command}`

    expect(File.exist?("newcli/spec/unit/.gitkeep"))
    expect(File.exist?("newcli/spec/support/.gitkeep"))
    expect(File.exist?("newcli/spec/integration/.gitkeep"))
  end

  it "generates a minitest test setup" do
    command = "teletype new newcli --test=minitest"
    `#{command}`

    expect(File.exist?("newcli/test/unit/.gitkeep"))
    expect(File.exist?("newcli/test/support/.gitkeep"))
    expect(File.exist?("newcli/test/integration/.gitkeep"))
  end
end
