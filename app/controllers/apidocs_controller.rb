class ApidocsController < ActionController::Base
  include Swagger::Blocks
  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Create Post API'
      key :description, 'A simple blog application where user can create blog add write comment etc.'
      contact do
        key :name, 'Suman Das'
      end
    end
    
    key :host, 'localhost:3000'
    key :basePath, '/api/v1'
    key :consumes, ['application/x-www-form-urlencoded'] #this means what responce we are going to send
    key :produces, ['application/json'] # and this means what type of responce we are going to get from user
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES_V1 = [
    #SwaggerController, #controller details goes from here where from you are creating api
    Api::V1::Authorizations::AuthenticateController,
    Api::V1::Authorizations::RegisterController,
    Api::V1::PostsController,
    Api::V1::CommentsController,
    SwaggerGlobalModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES_V1)
  end

  def swagger_ui
  end
end
