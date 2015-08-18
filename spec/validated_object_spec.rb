require 'spec_helper'

describe ValidatedObject do
  it 'has a version number' do
    expect(ValidatedObject::VERSION).not_to be nil
  end

  it 'can be referenced' do
    expect(ValidatedObject::Base).not_to be nil
  end
end
