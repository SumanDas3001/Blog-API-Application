require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation tests' do  
    it 'ensures name presence' do
      user = User.new(email: 'sample@example.com').save
      expect(user).to eq(false)
    end
    
    it 'ensures email presence' do
      user = User.new(name: 'Suman Das').save
      expect(user).to eq(false)
    end
    
    it 'should save successfully' do 
      user = User.new(name: 'Suman Das', email: 'sumandas@example.com', password: 'nopass', password_confirmation: 'nopass')
      expect(user).to be_valid
    end
  end
end
