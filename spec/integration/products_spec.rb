require 'swagger_helper'

RSpec.describe 'Products', type: :request do
  path '/api/v1/products' do
    get 'List all products' do
      tags 'Products'
      produces 'application/json'
      security [ bearer_auth: [] ]

  response '200', 'products found' do
        let!(:user) do
          User.create!(
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          )
        end

        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end

        let!(:product) do
          # Create products for the test
          Product.create!(name: "Apple", brand: "Dole", category: "Produce", image_url: "https://via.placeholder.com/100")
        end

        run_test!
      end
    end
  end
end
