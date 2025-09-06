class ApplicationController < ActionController::API
  private

  def auth_header
    request.headers["Authorization"]
  end

  def authorize_user
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    if decode_token
      user_id = decode_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    else
      render json: { message: "Did not find user." }, status: :unauthorized
    end
  end

  # Centralized JWT secret with fallback for test/dev via ENV
  def jwt_secret
    Rails.application.credentials.jwt_secret.presence || ENV["JWT_SECRET"]
  end

  def encode_token(payload)
    JWT.encode(payload, jwt_secret, "HS256")
  end

  # header: { 'Authorization': 'Bearer <token>' }
  def decode_token
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, jwt_secret, true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
