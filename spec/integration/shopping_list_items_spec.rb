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
      security [ bearer_auth: [] ]

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

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(201)
          expect(data).to be_a(Hash)
          expect(data).to include('id', 'product_id', 'product_name', 'quantity')
        end
      end
    end
  end

  path '/api/v1/shopping_lists/{shopping_list_id}/shopping_list_items/{id}' do
    parameter name: :shopping_list_id, in: :path, type: :string
    parameter name: :id, in: :path, type: :string

    delete 'Remove item from shopping list' do
      tags 'ShoppingListItems'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'item removed' do
        let!(:user) { User.create!(email: 'sldel@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store Z') }
        let!(:list) { ShoppingList.create!(user: user, store: store, name: 'With items') }
        let!(:product) { Product.create!(name: 'OJ', category: 'Drinks', brand: 'Tropicana', image_url: 'x') }
        let!(:item) { ShoppingListItem.create!(shopping_list: list, product: product, quantity: 1) }
        let(:shopping_list_id) { list.id }
        let(:id) { item.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data).to be_a(Hash)
          expect(data).to include('message')
          expect(data['message']).to eq('Item removed')
        end
      end
    end
  end
end
