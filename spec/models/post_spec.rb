require 'rails_helper'

RSpec.describe Post, type: :model do
  current_user = User.first_or_create!(name: 'Suman Das', email: 'suman@example.com', password: 'nopass', password_confirmation: 'nopass')

  it 'has a title' do
    post = Post.new(
      title: '',
      body: 'A valid body',
      user: current_user,
      post_like_count: 0
    )

    expect(post).to_not be_valid
    post.title = "Has a title"
    expect(post).to be_valid
  end

  it 'has a body' do
    post = Post.new(
      title: 'A valid title',
      body: '',
      user: current_user,
      post_like_count: 0
    )

    expect(post).to_not be_valid
    post.body = "Has a body"
    expect(post).to be_valid
  end

  it 'has a title at least 2 character long' do
    post = Post.new(
      title: '',
      body: 'A valid body',
      user: current_user,
      post_like_count: 0
    )
    expect(post).to_not be_valid
    post.title = '123'
    expect(post).to be_valid
  end

  it 'has a body between 5 to 100 character long' do
    post = Post.new(
      title: 'A valid title',
      body: '',
      user: current_user,
      post_like_count: 0
    )

    expect(post).to_not be_valid
    post.body = "12345"
    expect(post).to be_valid

    character_string = 'cH4QPtZV7ZtNKueIXldeHf8mLkPWP3iIde6k22s7xh583Pyd1oFno7TiuOw9JtnWtrBhmHowPAuhdThKhV2peAOIt2bO2lp7B1Tm'
    post.body = character_string
    expect(post).to be_valid
    post.body = character_string + '1'
    expect(post).not_to be_valid
  end

  it 'having at least one post count' do
    post = Post.new(
      title: 'A valid title',
      body: 'A valid body',
      user: current_user,
      post_like_count: 0
    )

    expect(post.post_like_count).not_to eq(1)
    post.post_like_count = 1
    expect(post.post_like_count).to eq(1)
  end
end
