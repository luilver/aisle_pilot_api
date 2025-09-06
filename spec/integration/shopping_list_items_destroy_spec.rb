require 'swagger_helper'

RSpec.describe 'Shopping List Items destroy', type: :request do
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

        run_test!
      end
    end
  end
end
