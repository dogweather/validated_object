# typed: ignore
# frozen_string_literal: true
require 'spec_helper'

describe ValidatedObject do
  class Apple < ValidatedObject::Base
    attr_accessor :diameter
    validates :diameter, type: Float
  end

  it 'has a version number' do
    expect(ValidatedObject::VERSION).not_to be nil
  end

  it 'can be referenced' do
    expect(ValidatedObject::Base).not_to be nil
  end

  it 'throws a TypeError if non-hash is given' do
    expect {
      Apple.new(5)
    }.to raise_error(TypeError)
  end

  it 'supports readonly attributes' do
    class ImmutableApple < ValidatedObject::Base
      attr_reader :diameter
      validates :diameter, type: Float
    end

    apple = ImmutableApple.new(diameter: 4.0)
    expect( apple.diameter ).to eq 4.0
    expect{ apple.diameter = 5.0 }.to raise_error(NoMethodError)
  end

  it 'raises error on unknown attribute' do
    expect {
      Apple.new(diameter: 4.0, name: 'Bert')
    }.to raise_error(NoMethodError)
  end

  context 'TypeValidator' do
    it 'verifies a valid type' do
      small_apple = Apple.new diameter: 2.0
      expect( small_apple ).to be_valid
    end

    it 'rejects an invalid type' do
      expect {
        Apple.new diameter: '2'
      }.to raise_error(ArgumentError)
    end

    it 'can verify a subclass' do
      class Apple3 < ValidatedObject::Base
        attr_accessor :diameter
        validates :diameter, type: Numeric
      end

      small_apple = Apple3.new diameter: 5
      expect( small_apple ).to be_valid
    end

    it 'handles Boolean types' do
      class Apple4 < ValidatedObject::Base
        attr_accessor :rotten
        validates :rotten, type: Boolean
      end

      rotten_apple = Apple4.new rotten: true
      expect( rotten_apple ).to be_valid
    end

    it 'rejects invalid boolean types' do
      class Apple5 < ValidatedObject::Base
        attr_accessor :rotten
        validates :rotten, type: Boolean
      end

      expect { Apple5.new rotten: 1 }.to raise_error(ArgumentError)
    end

  end
end
