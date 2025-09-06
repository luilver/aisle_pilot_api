require 'swagger_helper'

RSpec.describe 'Products extra', type: :request do
  path '/api/v1/products' do
    get 'List products filtered by store_id' do
      tags 'Products'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :store_id, in: :query, schema: { type: :integer }

      response '200', 'filtered products found' do
        let!(:user) { User.create!(email: 'pfilter@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store X') }
        let!(:product) { Product.create!(name: 'Apple', category: 'Produce', brand: 'Dole', image_url: 'x') }
        let!(:sp) { StoreProduct.create!(store: store, product: product, aisle: '1', location: { shelf: 1 }, price: 1.23) }
        let(:store_id) { store.id }

        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Get a product' do
      tags 'Products'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'product shown' do
        let!(:user) { User.create!(email: 'pshow@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:product) { Product.create!(name: 'Bananas', category: 'Produce', brand: 'Dole', image_url: 'x') }
        let(:id) { product.id }

        run_test!
      end
    end
  end
end
