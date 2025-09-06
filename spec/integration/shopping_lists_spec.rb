require 'swagger_helper'

RSpec.describe 'Shopping Lists', type: :request do
  path '/api/v1/shopping_lists' do
    get 'List current user shopping lists' do
      tags 'ShoppingLists'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'lists found' do
        let!(:user) { User.create!(email: 'sl@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end

        let!(:store) { Store.create!(name: 'Test Store') }
        let!(:list1) { ShoppingList.create!(user: user, store: store, name: 'Weekly') }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.first).to include('id', 'name', 'store_id')
        end
      end
    end

    post 'Create a shopping list' do
      tags 'ShoppingLists'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :shopping_list, in: :body, schema: {
        type: :object,
        required: %w[name store_id],
        properties: {
          name: { type: :string },
          store_id: { type: :integer }
        }
      }

      response '201', 'list created' do
        let!(:user) { User.create!(email: 'slc@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store A') }
        let(:shopping_list) { { name: 'Party', store_id: store.id } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(201)
          expect(data).to be_a(Hash)
          expect(data).to include('id', 'name', 'store_id')
        end
      end
    end
  end

  path '/api/v1/shopping_lists/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Get a shopping list' do
      tags 'ShoppingLists'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'list shown' do
        let!(:user) { User.create!(email: 'sls@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store B') }
        let!(:list) { ShoppingList.create!(user: user, store: store, name: 'Groceries') }
        let(:id) { list.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data).to be_a(Hash)
          expect(data).to include('id', 'name', 'store_id')
        end
      end
    end

    patch 'Update a shopping list' do
      tags 'ShoppingLists'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :shopping_list, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '200', 'list updated' do
        let!(:user) { User.create!(email: 'slu@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store C') }
        let!(:list) { ShoppingList.create!(user: user, store: store, name: 'Initial') }
        let(:id) { list.id }
        let(:shopping_list) { { name: 'Renamed' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data).to be_a(Hash)
          expect(data).to include('id', 'name', 'store_id')
        end
      end
    end

    delete 'Delete a shopping list' do
      tags 'ShoppingLists'
      produces 'application/json'
      security [ bearer_auth: [] ]

      response '200', 'list deleted' do
        let!(:user) { User.create!(email: 'sld@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store) { Store.create!(name: 'Store D') }
        let!(:list) { ShoppingList.create!(user: user, store: store, name: 'Temp') }
        let(:id) { list.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Shopping lists deleted')
        end
      end
    end
  end
end
