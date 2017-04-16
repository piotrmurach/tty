# encoding: utf-8

RSpec.describe 'rtty new --license', type: :cli do
  it "generates a MIT license file" do
    app_name = tmp_path('newcli')
    command = "bundle exec rtty new #{app_name} --license mit"
    `#{command}`
    license = File.binread(tmp_path('newcli/LICENSE.txt'))

    expect(license.lines[0]).to eq("The MIT License (MIT)\n")
  end

  it "generates a GPL-3.0 license file" do
    app_name = tmp_path('newcli')
    command = "bundle exec rtty new #{app_name} -l gplv3"
    `#{command}`
    license = File.binread(tmp_path('newcli/LICENSE.txt'))

    expect(license.lines[0]).to eq("GNU GENERAL PUBLIC LICENSE\n")
  end
end
