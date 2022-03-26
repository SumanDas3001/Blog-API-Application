module CommonUserHelper
  include Rails.application.routes.url_helpers
  def user_general_info(user, access_token, message)
    {
      response_code: 200,
      response_message: message,
      response_data:
      {
        user_id: user&.id || 0,
        email: user.email || "",
        name: user.name || "",
        access_token: access_token || "",
        token_type: 'bearer' || "",
      }
    }
  end

  def common_post_info(user, access_token, message)
    {
      response_code: 200,
      response_message: message,
      response_data: 
      {
        user_id: user&.id || 0,
        access_token: access_token || "",
        token_type: 'bearer' || "",
        post_model: user.posts.present? ? user.posts.order('created_at DESC').map {|post|{
          post_id: post&.id, status: post&.status, title: post&.title || "", body: post&.body || "", comment_count: post&.comments&.count || 0, post_like_count: post&.likes&.count || 0 } 
        } : [],
      }
    }
  end

  def post_show(user, post, access_token)
    post_show_data = {
      user_id: user&.id || 0,
      access_token: access_token || "",
      token_type: 'bearer' || "",
      post_details_reponse_data: post_show_info(post) || {},
    }
  end

  def create_comment_response(comment)
    comment_response_data = {
      post_id: comment&.post_id,
      comment_id: comment.id,
      text: comment&.text || "",
      comment_like_count: comment&.likes&.count || 0
    }
  end

  def post_show_info(post)
    post_show_info_data = {
      post_id: post&.id, 
      status: post&.status,
      title: post&.title || "", 
      body: post&.body || "", 
      comment_count: post&.comments&.count || 0, 
      post_like_count: post&.likes&.count || 0,
      comment_model: comment_info(post&.comments) || []
    }
  end

  def comment_info(comments)
    comment_response_data = []
    comments.map{|comment|
      comment_response_data << {
        post_id: comment&.post&.id,
        comment_id: comment.id,
        text: comment&.text,
        comment_like_count: comment&.likes&.count || 0
      }
    }
    return comment_response_data
  end


  def success_response(message)
    response = {}
    user = @user
    response = auth_headers(response, user)
    @access_token = response[:body]
    render json: user_general_info(@user, @access_token[:access_token], message)
  end

  def get_users_data(users)
    users.each do |user|
      data << {
        user_id: user.id,
        email: user.email,
        name: user.name  || "",
        number_of_posts: user.posts.present? ? user.posts.count : 0
      }
    end
    return data
  end


  
end