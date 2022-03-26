module JwtAuthenticate
  def authorize_user!
    user, payload = fetch_user_payload_from_token
    @user = user
  
    return unless ::User.jwt_revoked?(payload, user)
    error_model(401, 'Email, Password or access token Incorrect')
  rescue StandardError
    unauthorized_401_error(401, "#{I18n.t 'you_are_not_logged_in'}")
  end

  def current_token
    auth_header = request.env['HTTP_AUTHORIZATION']
    auth_header.split(' ').last
  end

  def fetch_user_payload_from_token
    token = current_token
    payload = decode_token token
    user = ::User.find_for_jwt_authentication(payload['sub'])
    [user, payload]
  end

  def auth_headers(response, user, scope: nil, aud: 'User')
    scope ||= Devise::Mapping.find_scope!(user)
    aud ||= headers[Warden::JWTAuth.config.aud_header]
    Warden::JWTAuth.config.expiration_time = 1296000 
    token, payload = encode_token(user, scope)
    expiry = payload['exp'] - payload['iat']
    response[:body] = { access_token: token, token_type: 'bearer',
                        expires_in: expiry, created_at: payload['iat'] }
    
    response
  end

  def encode_token(user, scope)
    Warden::JWTAuth::UserEncoder.new.call(user, scope, aud: 'User')
  end

  def decode_token(token)
    Warden::JWTAuth::TokenDecoder.new.call(token)
  end

  def set_error_response(message, description, status)
    self.response_body = {
      status: message,
      message: description
    }.to_json
    self.status = status
  end
end
