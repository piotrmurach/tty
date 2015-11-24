# encoding: utf-8

require 'spec_helper'

RSpec.describe TTY::Terminal::Home, '#find_home' do
  context 'on unix' do
    it "finds home" do
      platform = spy(:windows? => false)
      home = described_class.new(platform)
      allow(home).to receive(:unix_home).and_return('/users/piotr')
      allow(File).to receive(:expand_path).and_return('/users/piotr')
      expect(home.find_home).to eq('/users/piotr')
      expect(home).to have_received(:unix_home)
    end
  end

  context 'on windows' do
    it "finds home" do
      platform = spy(:windows? => true)
      home = described_class.new(platform)
      allow(home).to receive(:windows_home).and_return('C:\Users\Piotr')
      allow(File).to receive(:expand_path).and_return('C:\Users\Piotr')
      expect(home.find_home).to eq('C:\Users\Piotr')
      expect(home).to have_received(:windows_home)
    end
  end
end
