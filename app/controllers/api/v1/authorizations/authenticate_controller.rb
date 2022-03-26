module Api::V1
  module Authorizations
    class AuthenticateController < Devise::SessionsController
      include Response
      include CommonUserHelper
      include JwtAuthenticate
      include Swagger::Blocks

      before_action :authorize_user!, only: [:revoke]

      swagger_path '/login' do
        operation :post do
          key :summary, 'Api for user sign_in'
          key :description, 'Api for user sign_in'
          key :tags, [
            'Authentication'
          ]
          parameter do
            key :name, :email
            key :in, :formData
            key :description, 'Email Address'
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, :password
            key :in, :formData
            key :description, 'Password'
            key :format, :password
            key :required, true
            key :type, :string
          end
          response 200 do
            key :description, 'Successfull'
            schema do
              key :'$ref', :register_user
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

      def create
        @response = {}
        @user = ::User.find_by('email = ?', params[:email])

        unless @user.exist?
          error_model(400, I18n.t('email_not_match'))
          return
        end

        if resource_owner_from_credentials(@user.email)
          @response = auth_headers(@response, @user)
          @response[:status] = :ok
        else
          error_model(400, I18n.t('password_not_match'))
          return
        end
        create_response
      end

      swagger_path '/revoke' do
        operation :delete do
          key :summary, 'Api for user logout'
          key :description, 'Api for user logout'
          key :tags, ['Authentication']

          parameter do
            key :name, :Authorization
            key :description, 'Enter Authorization Key'
            key :type, :string
            key :in, :header
            key :required, true
          end

          response 200 do
            key :description, 'Success'
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

      def revoke
        user, payload = fetch_user_payload_from_token
        User.revoke_jwt(payload, user)
        success_model(200, I18n.t('user_logout_success'))
      end

  
      swagger_path '/user_list' do
        operation :get do
          key :summary, 'List of all users(having at least one post) and count of their'
          key :description, 'List of all users(having at least one post) and count of their'
          key :tags, ['Authentication']
          response 200 do
            key :description, 'Successfull'
            schema do
              key :'$ref', :user_list_data
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

      swagger_schema :user_list_data do
        key :required, %i[response_code response_message]
        property :response_code do
          key :type, :integer
        end
        property :response_message do
          key :type, :string
        end
        property :response_data do
          key :type, :array
          items do
            key :'$ref', :user_list_data_response
          end
        end
      end
  
      def user_list
        response = []
        @list_of_all_user_with_post = User&.includes(:posts)&.order('created_at DESC')
        if @list_of_all_user_with_post.present?
          @list_of_all_user_with_post.map do |user|
            response << {
              user_id: user.id,
              number_of_posts: user&.posts&.count || 0
            }
          end

          singular_success_model(200, I18n.t('user_success_list'), response)
        else
          error_model(404, I18n.t('post_not_found'))
        end
      rescue StandardError => e
        error_model(403, e.message)
      end

      private

      def resource_owner_from_credentials(email)
        user = ::User.find_for_database_authentication(email: email)
        return if user.blank?

        return_user = (user&.valid_for_authentication? { user.valid_password?(params[:password]) })
        user if return_user
      end

      def create_response
        if @user.blank?
          set_error_response('Error', 'Record not found', :not_found)
        elsif @response[:status].to_s == 'unauthorized'
          fetch_unauthorized_response
        else
          login_criteria = after_database_authentication
          if login_criteria[:success] == true
            render(json: user_general_info(@user, @response[:body][:access_token], I18n.t('logged_in_success')))
          elsif login_criteria[:success] == false
            error_model(400, login_criteria[:message])
          end
        end
      end

      def fetch_unauthorized_response
        unauthorize_msg = 'Email, Password or access token Incorrect'
        @response[:error] = unauthorize_msg if @response[:error].blank?
        unauthorized_401_error(401, @response[:error])
      end

      def after_database_authentication
        return { success: true }
      end
    end
  end
end
