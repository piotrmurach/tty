# encoding: utf-8

RSpec.describe 'teletype new --test', type: :cli do
  it "generates a rspec test setup" do
    app_name = tmp_path('newcli')
    command = "bundle exec teletype new #{app_name} --test rspec"
    `#{command}`

    expect(File.exist?('newcli/spec/unit/.gitkeep'))
    expect(File.exist?('newcli/spec/support/.gitkeep'))
    expect(File.exist?('newcli/spec/integration/.gitkeep'))
  end

  it "generates a minitest test setup" do
    app_name = tmp_path('newcli')
    command = "bundle exec teletype new #{app_name} --test=minitest"
    `#{command}`

    expect(File.exist?('newcli/test/unit/.gitkeep'))
    expect(File.exist?('newcli/test/support/.gitkeep'))
    expect(File.exist?('newcli/test/integration/.gitkeep'))
  end
end
