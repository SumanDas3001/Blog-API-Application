class SwaggerGlobalModel
  include Swagger::Blocks

  swagger_schema :common_response_model do
    key :required, [:response_code, :response_message]
    property :response_code do
      key :type, :integer
      key :format, :int32
    end
    property :response_message do
      key :type, :string
    end
  end

  swagger_schema :register_user do
    key :required, [:response_code, :response_message]
    property :response_code do
      key :type, :integer
    end
    property :response_message do
      key :type, :string
    end
    property :response_data do
      key :'$ref', :user
    end
  end
  swagger_schema :user do
    key :required, [:user_id, :email, :name, :access_token, :token_type]
    property :user_id do
      key :type, :integer
    end
    property :email do
      key :type, :string
    end
    property :name do
      key :type, :string
    end
    property :access_token do
      key :type, :string
    end
    property :token_type do
      key :type, :string
    end
  end

  swagger_schema :post_model do
    key :required, [:response_code, :response_message]
    property :response_code do
      key :type, :integer
    end
    property :response_message do
      key :type, :string
    end
    property :response_data do
      key :'$ref', :UserPostDetails
    end
  end

  swagger_schema :UserPostDetails do
    property :user_id do
      key :type, :integer
    end
    property :access_token do
      key :type, :string
    end
    property :token_type do
      key :type, :string
    end
    property :post_model do
      key :type, :array
      items do
        key :'$ref', :PostDetails
      end
    end
  end

  swagger_schema :PostDetails do
    property :post_id do
      key :type, :integer
    end
    property :status do
      key :type, :string
    end
    property :title do
      key :type, :string
    end
    property :body do
      key :type, :string
    end
    property :comment_count do
      key :type, :integer
    end
    property :post_like_count do
      key :type, :integer
    end
  end

  swagger_schema :post_details_reponse do
    property :user_id do
      key :type, :integer
    end
    property :access_token do
      key :type, :string
    end
    property :token_type do
      key :type, :string
    end
    property :post_details_reponse_data do
      key :'$ref', :PostAndCommentDetailsResponse
    end
  end


  swagger_schema :PostAndCommentDetailsResponse do
    property :post_id do
      key :type, :integer
    end
    property :status do
      key :type, :string
    end
    property :title do
      key :type, :string
    end
    property :body do
      key :type, :string
    end
    property :comment_count do
      key :type, :integer
    end
    property :post_like_count do
      key :type, :integer
    end
    property :comment_model do
      key :type, :array
      items do
        key :'$ref', :CommentResponseData
      end
    end
  end

  swagger_schema :CommentResponseData do
    property :post_id do
      key :type, :integer
    end
    property :comment_id do
      key :type, :integer
    end
    property :text do
      key :type, :string
    end
    property :comment_like_count do
      key :type, :integer
    end
  end

  swagger_schema :user_list_data_response do
    property :user_id do
      key :type, :integer
    end
    property :number_of_posts do
      key :type, :integer
    end
  end
end
