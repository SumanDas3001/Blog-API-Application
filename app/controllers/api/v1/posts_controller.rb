module Api::V1
  class PostsController < ApplicationController
    include CommonUserHelper
    include Swagger::Blocks

    before_action :authorize_user!

    swagger_path "/posts" do
      operation :get do
        key :summary, "Total number of likes and comments a user received for each of his/her post"
        key :description, "Total number of likes and comments a user received for each of his/her post"
        key :tags, ['Post']
        parameter do
          key :name, :Authorization
          key :description, "Enter Authorization Key"
          key :type, :string
          key :in, :header
          key :required, true
        end
        response 200 do
          key :description, "Successfull"
          schema do
            key :'$ref', :post_model
          end
        end
        response 400 do
          key :description, "Error"
          schema do
            key :'$ref', :common_response_model
          end
        end
      end
    end

    def index
      begin
        @posts = @user.posts rescue []
        if @posts.present?
          render json: common_post_info(@user, current_token, "#{I18n.t 'post_list_success'}")
        else
          error_model(404, "#{I18n.t 'post_not_found'}")
        end
      rescue Exception => e
        error_model(403, e.message)
      end
    end

    swagger_path "/posts/{id}" do
      operation :get do
        key :summary, "API for viewing a post with all of its comments and count of likes for the post, count of likes for each comment and read post"
        key :description, "API for viewing a post with all of its comments and count of likes for the post, count of likes for each comment and read post"
        key :tags, ['Post']
        parameter do
          key :name, :Authorization
          key :description, "Enter Authorization Key"
          key :type, :string
          key :in, :header
          key :required, true
        end
        parameter do
          key :name, :id
          key :in, :path
          key :description, 'Post Id'
          key :required, true
          key :type, :integer
        end
        parameter do
          key :name, 'status'
          key :in, :query
          key :description, 'status = {"unread": 0, "read": 1} / Default status is unread'
          key :required, false
          key :type, :integer
        end
        response 200 do
          key :description, "Successfull"
          schema do
            key :'$ref', :show_post
          end
        end
        response 400 do
          key :description, "Error"
          schema do
            key :'$ref', :common_response_model
          end
        end
      end
    end

    swagger_schema :show_post do
      key :required, [:response_code, :response_message]
      property :response_code do
        key :type, :integer
      end
      property :response_message do
        key :type, :string
      end
      property :response_data do
        key :'$ref', :post_details_reponse
      end
    end

    def show
      begin
        @post = Post.find_by(id: params[:id]) rescue []
        unless @post.present?
          error_model(404, "#{I18n.t 'post_not_found'}")
          return
        end
        @post.update(status: params[:status].to_i) if params[:status].present?
        singular_success_model(200, "#{I18n.t 'post_show_data'}", post_show(@user, @post, current_token))
      rescue Exception => e
        error_model(403, e.message)
      end
    end

    swagger_path "/posts" do
      operation :post do
        key :summary, "API for creating a post"
        key :description, "API for creating a post"
        key :tags, ['Post']
        parameter do
          key :name, :Authorization
          key :description, "Enter Authorization Key"
          key :type, :string
          key :in, :header
          key :required, true
        end
        parameter do
          key :name, 'title'
          key :in, :formData
          key :description, 'Title'
          key :required, true
          key :type, :string
        end
        parameter do
          key :name, 'body'
          key :in, :formData
          key :description, 'Body'
          key :required, true
          key :type, :string
        end
        response 200 do
          key :description, "Successfull"
          schema do
            key :'$ref', :post_model
          end
        end
        response 400 do
          key :description, "Error"
          schema do
            key :'$ref', :common_response_model
          end
        end
      end
    end

    def create
      begin
        @post = Post.new(post_params)
        @post.user_id = @user.id
        @post.status = params[:status].to_i if params[:status].present?

        if @post.save
          render json: common_post_info(@user, current_token, "#{I18n.t 'post_create_success'}")
        else
          error_model(400, @post.errors.full_messages.join(','))
        end
      rescue Exception => e
        error_model(403, e.message)
      end
    end

    swagger_path "/posts/{id}/like_post" do
      operation :post do
        key :summary, "Api for like a post"
        key :description, "Api for like a post"
        key :tags, ['Post']
        parameter do
          key :name, :Authorization
          key :description, "Enter Authorization Key"
          key :type, :string
          key :in, :header
          key :required, true
        end
        parameter do
          key :name, 'id'
          key :in, :path
          key :description, 'Post Id'
          key :required, true
          key :type, :integer
        end
        response 200 do
          key :description, "Successfull"
          schema do
            key :'$ref', :common_response_model
          end
        end
        response 400 do
          key :description, "Error"
          schema do
            key :'$ref', :common_response_model
          end
        end
      end
    end

    def like_post
      begin
        @post = Post.find_by(id: params[:id]) rescue []
        unless @post.present?
          error_model(404, "#{I18n.t 'post_not_found'}")
          return
        end

        @like_post = @post.likes.new(likeable: @post, user_id: @user.id)
        if @like_post.save!
          success_model(200, "#{I18n.t 'post_like_successfully'}")
        else
          error_model(400, @like_post.errors.full_messages.join(','))
        end 

      rescue Exception => e
        error_model(403, e.message)
      end
    end

    private
    
    def post_params
      params.permit(:title, :body)
    end

  end
end