# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic do

  subject { described_class.new }

  it { should respond_to(:render) }

end
