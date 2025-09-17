module Api
  module V1
    class AuthController < ApplicationController
      # POST /api/v1/login
      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { user: user_response(user), token: token }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # POST /api/v1/register
      def register
        User.new(user_params).tap do |user|
          if user.save
            token = encode_token({ user_id: user.id })
            render json: { user: user_response(user), token: token }, status: :created
          else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

      private

      def user_params
        params.permit(:email, :name, :password, :password_confirmation)
      end

      def user_response(user)
        {
          id: user.id,
          name: user.name,
          email: user.email
        }
      end

      def encode_token(payload)
        jwt_secret = Rails.application.credentials.jwt_secret.presence || ENV["JWT_SECRET"] || "your_super_secret_jwt_key_for_development_12345_changeme_in_production"
        JWT.encode(payload, jwt_secret, "HS256")
      end
    end
  end
end
