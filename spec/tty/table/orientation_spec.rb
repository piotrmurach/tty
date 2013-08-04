# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'orientation' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:options) { { :orientation => orientation } }

  subject { described_class.new(header, rows, options) }

  context 'when illegal option' do
    let(:orientation) { :accross }

    it { expect { subject }.to raise_error(TTY::InvalidOrientationError) }
  end

  context 'when horizontal' do
    let(:orientation) { :horizontal }

    its(:orientation) { should be_kind_of TTY::Table::Orientation }

    it { expect(subject.orientation.name).to eql :horizontal }

    it { expect(subject.header).to eql header }

    it 'preserves original rows' do
      expect(subject.to_a).to eql(subject.data)
    end

    context 'without border' do
      it 'displays table' do
        subject.to_s.should == <<-EOS.normalize
          h1 h2 h3
          a1 a2 a3
          b1 b2 b3
        EOS
      end
    end

    context 'with border' do
      let(:renderer) { :ascii }

      it 'diplays table' do
        subject.render(renderer).should == <<-EOS.normalize
         +--+--+--+
         |h1|h2|h3|
         +--+--+--+
         |a1|a2|a3|
         |b1|b2|b3|
         +--+--+--+
        EOS
      end
    end
  end

  context 'when vertical' do
    let(:orientation) { :vertical }

    its(:orientation) { should be_kind_of TTY::Table::Orientation }

    it { expect(subject.orientation.name).to eql :vertical }

    it { expect(subject.header).to be_empty }

    context 'with header' do
      it 'rotates original rows' do
        rotated_rows = [['h1','a1'],['h2','a2'],['h3','a3'], ['h1','b1'],['h2','b2'],['h3','b3']]
        expect(subject.to_a).to eql rotated_rows
      end

      context 'without border' do
        it 'displays table' do
          subject.to_s.should == <<-EOS.normalize
            h1 a1
            h2 a2
            h3 a3
            h1 b1
            h2 b2
            h3 b3
          EOS
        end
      end

      context 'with border' do
        let(:renderer) { :ascii }

        it 'diplays table' do
          subject.render(renderer).should == <<-EOS.normalize
          +--+--+
          |h1|a1|
          |h2|a2|
          |h3|a3|
          |h1|b1|
          |h2|b2|
          |h3|b3|
          +--+--+
          EOS
        end
      end
    end

    context 'without header' do
      let(:header) { nil }

      it 'rotates original rows' do
        rotated_rows = [['1','a1'],['2','a2'],['3','a3'], ['1','b1'],['2','b2'],['3','b3']]
        expect(subject.to_a).to eql rotated_rows
      end

      context 'without border' do
        it 'displays table' do
          subject.to_s.should == <<-EOS.normalize
            1 a1
            2 a2
            3 a3
            1 b1
            2 b2
            3 b3
          EOS
        end
      end

      context 'with border' do
        let(:renderer) { :ascii }

        it 'diplays table' do
          subject.render(renderer).should == <<-EOS.normalize
          +-+--+
          |1|a1|
          |2|a2|
          |3|a3|
          |1|b1|
          |2|b2|
          |3|b3|
          +-+--+
          EOS
        end
      end
    end
  end

end # orientation
