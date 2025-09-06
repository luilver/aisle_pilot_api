require 'swagger_helper'

RSpec.describe 'Shopping List Items', type: :request do
  path '/api/v1/shopping_lists/{id}/shopping_list_items' do
    post 'Add item to shopping list' do
      tags 'ShoppingListItems'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :item, in: :body, schema: {
        type: :object,
        required: %w[product_id quantity],
        properties: {
          product_id: { type: :integer },
          quantity: { type: :integer }
        }
      }
      security [Bearer: []]
      parameter name: :Authorization, in: :header, type: :string

      response '201', 'item added' do
  let(:store) { Store.create!(name: "Test Store") }
        let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "password") }
        let(:product) { Product.create!(name: "Test Product") }
        let(:shopping_list) { ShoppingList.create!(user: user, store: store) }
        let(:id) { shopping_list.id }

        let(:item) do
          { product_id: product.id, quantity: 2 }
        end

        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end

        run_test!
      end
    end
  end
end
