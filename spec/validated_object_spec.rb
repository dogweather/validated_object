require 'spec_helper'

describe ValidatedObject do
  it 'has a version number' do
    expect(ValidatedObject::VERSION).not_to be nil
  end

  it 'can be referenced' do
    expect(ValidatedObject::Base).not_to be nil
  end
  
  it 'can check a type - 1' do
    class Apple < ValidatedObject::Base
      attr_accessor :diameter
      validates :diameter, type: Float
    end
    
    small_apple = Apple.new { |a| a.diameter = 2.0  }
    expect( small_apple ).to be_valid
  end

  it 'can check a type - 2' do
    class Apple < ValidatedObject::Base
      attr_accessor :diameter
      validates :diameter, type: Float
    end
    
    expect {
      small_apple = Apple.new { |a| a.diameter = '2'  }
    }.to raise_error(ArgumentError)
  end
end
