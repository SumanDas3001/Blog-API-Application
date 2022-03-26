module Api
  module V1
    class CommentsController < ApplicationController
      include CommonUserHelper
      include Swagger::Blocks

      before_action :authorize_user!

      swagger_path '/comments' do
        operation :post do
          key :summary, 'Api for write comment'
          key :description, 'Api for write comment'
          key :tags, ['Comment']
          parameter do
            key :name, :Authorization
            key :description, 'Enter Authorization Key'
            key :type, :string
            key :in, :header
            key :required, true
          end
          parameter do
            key :name, 'post_id'
            key :in, :formData
            key :description, 'Text'
            key :required, true
            key :type, :integer
          end
          parameter do
            key :name, 'text'
            key :in, :formData
            key :description, 'Text'
            key :required, true
            key :type, :string
          end
          response 200 do
            key :description, 'Successfull'
            schema do
              key :'$ref', :comment_model
            end
          end
          response 400 do
            key :description, 'Error'
            schema do
              key :'$ref', :common_response_model
            end
          end
        end
      end

      swagger_schema :comment_model do
        key :required, [:response_code, :response_message]
        property :response_code do
          key :type, :integer
        end
        property :response_message do
          key :type, :string
        end
        property :response_data do
          key :'$ref', :CommentResponseData
        end
      end

      def create
        @post = Post.find(params[:post_id])
        if @post.blank?
          error_model(404, I18n.t('post_not_found'))
        else
          @comment = @post.comments.create!(comment_params)
          @comment.user_id = @user.id
        end
        if @comment.save
          singular_success_model(200, I18n.t('create_comment'), create_comment_response(@comment))
        else
          error_model(400, @comment.errors.full_messages.join(','))
        end
      rescue StandardError => e
        error_model(403, e.message)
      end

      swagger_path '/comments/{id}/like_comment' do
        operation :post do
          key :summary, 'Api for like comment'
          key :description, 'Api for like comment'
          key :tags, ['Comment']
          parameter do
            key :name, :Authorization
            key :description, 'Enter Authorization Key'
            key :type, :string
            key :in, :header
            key :required, true
          end
          parameter do
            key :name, 'id'
            key :in, :path
            key :description, 'Comment Id'
            key :required, true
            key :type, :integer
          end
          response 200 do
            key :description, 'Successfull'
            schema do
              key :'$ref', :common_response_model
            end
          end
          response 400 do
            key :description, 'Error'
            schema do
              key :'$ref', :common_response_model
            end
          end
        end
      end
  
      def like_comment
        @comment = Comment.find_by(id: params[:id])
        if @comment.blank?
          error_model(404, I18n.t('post_not_found'))
        else
          @like_comment = @comment.likes.new(likeable: @comment, user_id: @user.id)
        end

        if @like_comment.save!
          success_model(200, I18n.t('comment_like_successfully'))
        else
          error_model(400, @like_comment.errors.full_messages.join(','))
        end
      rescue StandardError => e
        error_model(403, e.message)
      end

      private
      def comment_params
        params.permit(:text, :post_id)
      end
    end
  end
end