require 'rails_helper'

RSpec.describe('Posts API', type: :request) do
  describe 'GET /todos' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    it 'should get user and post' do
      puts User.all.inspect.to_s
      puts post.inspect.to_s
    end
  end
end
