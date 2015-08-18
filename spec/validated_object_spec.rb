require 'spec_helper'

describe ValidatedObject do
  it 'has a version number' do
    expect(ValidatedObject::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
