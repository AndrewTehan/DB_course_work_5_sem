require 'rails_helper'

RSpec.describe Master, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "is valid with valid attributes" do
    expect(Master.new(:master)).to be_valid
  end
end
