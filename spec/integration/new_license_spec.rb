# encoding: utf-8

RSpec.describe 'rtty new --license', type: :cli do
  it "generates a license file" do
    app_name = tmp_path('newcli')
    command = "bundle exec rtty new #{app_name} --license mit"
    `#{command}`
    license = File.binread(tmp_path('newcli/LICENSE.txt'))

    expect(license.lines[0..2]).to eq([
      "The MIT License (MIT)\n",
      "\n",
      "Copyright (c) 2017 Piotr Murach\n"
    ])
  end
end
