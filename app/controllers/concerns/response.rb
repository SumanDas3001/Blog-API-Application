module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def response_with_message(status, message)
    {
      status: status,
      message: message
    }
  end

  def response_with_id(status, message, id)
    {
      status: status,
      message: message,
      id: id
    }
  end

  def not_found(message = 'Record not found')
    render json: response_with_message('Error', message), status: :not_found
  end

  def error_model(code, message)
    render :json => {
      response_code: code,
      response_message: message
    }
    return
  end

  def success_model(code, message)
    render :json => {
      response_code: code,
      response_message: message
    }
    return
  end
  
  def unauthorized_401_error(code, message)
    render :json => {
      response_code: code,
      response_message: message
    }
    return
  end

  def singular_success_model(code, message, object)
    render :json => {
      response_code: status,
      response_message: message,
      response_data: object
    }
  end
end
