# frozen_string_literal: true
require 'spec_helper'

describe ValidatedObject do
  it 'has a version number' do
    expect(ValidatedObject::VERSION).not_to be nil
  end

  it 'can be referenced' do
    expect(ValidatedObject::Base).not_to be nil
  end

  context 'TypeValidator' do
    it 'verifies a valid type' do
      class Apple1 < ValidatedObject::Base
        attr_accessor :diameter
        validates :diameter, type: Float
      end

      small_apple = Apple1.new { |a| a.diameter = 2.0 }
      expect( small_apple ).to be_valid
    end

    it 'rejects an invalid type' do
      class Apple2 < ValidatedObject::Base
        attr_accessor :diameter
        validates :diameter, type: Float
      end

      expect {
        Apple2.new { |a| a.diameter = '2' }
      }.to raise_error(ArgumentError)
    end

    it 'can verify a subclass' do
      class Apple3 < ValidatedObject::Base
        attr_accessor :diameter
        validates :diameter, type: Numeric
      end

      small_apple = Apple3.new { |a| a.diameter = 5 }
      expect( small_apple ).to be_valid
    end

    it 'handles Boolean types' do
      class Apple4 < ValidatedObject::Base
        attr_accessor :rotten
        validates :diameter, type: Boolean
      end

      small_apple = Apple3.new { |a| a.rotten = true }
      expect( small_apple ).to be_valid
    end
  end
end
