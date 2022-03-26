require 'rails_helper'

RSpec.describe Comment, type: :model do
    let(:current_user) { User.first_or_create!(name: 'Suman Das', email: 'suman@example.com', password: 'nopass', password_confirmation: 'nopass')}
    let(:post) { Post.create!(title: 'A valid title', body: 'Has a body', user: current_user) }
  
  it 'has a text' do
    comment = Comment.new(
      text: '',
      user: current_user,
      post: post
    )

    expect(comment).to_not be_valid
    comment.text = "Has a text"
    expect(comment).to be_valid
  end
end
