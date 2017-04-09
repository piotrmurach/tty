# encoding: utf-8

RSpec.describe TTY::CLI do
  it "creates new app" do
    expect(`exe/rtty new app`).to match("Creating gem 'app'")
  end
end
