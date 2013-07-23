# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer, '#border' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:border) { nil }

  let(:table) { TTY::Table.new(header, rows) }

  subject { described_class.select(renderer).new(table) }

  context 'when default' do
    let(:renderer) { :basic }
    let(:border) { { :characters => {'top' => '-'}, :style => :red } }

    it 'specifies border in hash' do
      subject.border border
      expect(subject.border.characters['top']).to eql('-')
    end

    it 'specifies border in characters attribute' do
      subject.border.characters = {'top' => '*'}
      expect(subject.border.characters['top']).to eql('*')
    end

    it 'specifies border in block' do
      subject.border do
        mid          '='
        mid_mid      ' '
      end

      subject.render.should == <<-EOS.normalize
        h1 h2 h3
        == == ==
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'when ascii' do
    let(:renderer) { :ascii }

    it 'specifies border in block' do
      subject.border do
        mid          '='
        mid_mid      '='
        mid_left     '='
        mid_right    '='
      end

      subject.render.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        ==========
        |a1|a2|a3|
        |b1|b2|b3|
        +--+--+--+
      EOS
    end

    it 'specifies border as hash' do
      subject.border({ :characters => {
        'mid'       => '=',
        'mid_mid'   => '=',
        'mid_left'  => '=',
        'mid_right' => '=',
      }})

      subject.render.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        ==========
        |a1|a2|a3|
        |b1|b2|b3|
        +--+--+--+
      EOS
    end
  end

  context 'when unicode' do
    let(:renderer) { :unicode }

    it 'specifies border in block' do
      subject.border do
        mid          '='
        mid_mid      '='
        mid_left     '='
        mid_right    '='
      end

      subject.render.should == <<-EOS.normalize
        ┌──┬──┬──┐
        │h1│h2│h3│
        ==========
        │a1│a2│a3│
        │b1│b2│b3│
        └──┴──┴──┘
      EOS
    end
  end
end # border
