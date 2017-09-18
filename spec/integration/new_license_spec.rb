# encoding: utf-8

RSpec.describe 'teletype new --license', type: :cli do
  it "generates a MIT license file" do
    app_name = tmp_path('newcli')
    command = "bundle exec teletype new #{app_name} --license mit"
    `#{command}`

    license = File.binread(tmp_path('newcli/LICENSE.txt'))
    gemspec = File.binread(tmp_path('newcli/newcli.gemspec'))

    expect(license.lines[0]).to eq("The MIT License (MIT)\n")
    expect(gemspec).to match(/spec.license\s*=\s*"MIT"/)
  end

  it "generates a GPL-3.0 license file" do
    app_name = tmp_path('newcli')
    command = "bundle exec teletype new #{app_name} -l gplv3"
    `#{command}`

    license = File.binread(tmp_path('newcli/LICENSE.txt'))
    gemspec = File.binread(tmp_path('newcli/newcli.gemspec'))

    expect(license.lines[0]).to eq("GNU GENERAL PUBLIC LICENSE\n")
    expect(gemspec).to match(/spec.license\s*=\s*"GPL-3.0"/)
  end

  it "fails to recognise the license type" do
    app_name = tmp_path('newcli')
    command = "bundle exec teletype new #{app_name} --license unknown"
    out, err, process = Open3.capture3(command)

    expect(out).to eq('')
    expect(err).to eq("Expected '--license' to be one of agplv3, apache, gplv2, gplv3, lgplv3, mit, mplv2, custom; got unknown\n")
    expect(process.exitstatus).to eq(0) # FIXME: wrong status
  end
end
