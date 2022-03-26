module Api::V1
  module Authorizations
    class RegisterController < Devise::RegistrationsController
      include Response
      include CommonUserHelper
      include JwtAuthenticate
      include Swagger::Blocks

      swagger_path '/register' do
        operation :post do
          key :consumes, ['multipart/form-data']
          key :summary, 'Api for user signup'
          key :description, 'Api for user signup'
          key :tags, [
            'Authentication'
          ]
          parameter do
            key :name, 'user[name]'
            key :in, :formData
            key :description, 'Name'
            key :required, true
            key :type, :string
          end
          parameter do
            key :name, 'user[email]'
            key :in, :formData
            key :description, 'email'
            key :required, true
            key :type, :string
          end
          
          parameter do
            key :name, 'user[password]'
            key :in, :formData
            key :description, 'password'
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
        ActiveRecord::Base.transaction do
          @user = ::User.new(user_params)
          if @user.save! 
            success_response(I18n.t('employee_create_success'))
          else
            error_model(400, @user.errors.full_messages.join(','))
            raise ActiveRecord::Rollback
          end
        end
      rescue StandardError => e
        error_model(403, e.message)
      end

      private
      def user_params
        params.require(:user).permit(:email, :password, :name)
      end
    end
  end
end
