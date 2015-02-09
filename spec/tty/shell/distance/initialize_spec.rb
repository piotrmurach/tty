# encoding: utf-8

require 'spec_helper'

describe TTY::Text::Distance, '#initialize' do
  let(:strings) { ['abc', 'acb'] }

  subject(:distance) { described_class.new(*strings) }

  it { expect(distance.first).to eq(strings.first) }

  it { expect(distance.second).to eq(strings.last) }

end # initialize
