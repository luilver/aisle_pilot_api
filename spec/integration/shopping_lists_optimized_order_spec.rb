require 'swagger_helper'

RSpec.describe 'Shopping Lists Optimized Order', type: :request do
  path '/api/v1/shopping_lists/{id}/optimized_order' do
    parameter name: :id, in: :path, type: :integer, description: 'Shopping list ID'

    get 'Get optimized shopping order for a list' do
      tags 'ShoppingLists'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'optimized shopping order' do
        let!(:user) { User.create!(email: 'optimized@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end

        let!(:store) { Store.create!(name: 'Test Store', location: 'Test Location') }
        let!(:product1) { Product.create!(name: 'Bananas', category: 'Produce', brand: 'Dole', image_url: 'test.jpg') }
        let!(:product2) { Product.create!(name: 'Milk', category: 'Dairy', brand: 'Great Value', image_url: 'test.jpg') }
        let!(:product3) { Product.create!(name: 'Bread', category: 'Bakery', brand: 'Wonder', image_url: 'test.jpg') }
        
        let!(:store_product1) { StoreProduct.create!(store: store, product: product1, aisle: '1', location: { shelf: 1, bin: 1 }, price: 2.99) }
        let!(:store_product2) { StoreProduct.create!(store: store, product: product2, aisle: '2', location: { shelf: 2, bin: 1 }, price: 3.49) }
        let!(:store_product3) { StoreProduct.create!(store: store, product: product3, aisle: '4', location: { shelf: 1, bin: 3 }, price: 2.49) }
        
        let!(:shopping_list) { ShoppingList.create!(user: user, store: store, name: 'Test List') }
        let!(:item1) { ShoppingListItem.create!(shopping_list: shopping_list, product: product1, quantity: 2, notes: 'Ripe ones') }
        let!(:item2) { ShoppingListItem.create!(shopping_list: shopping_list, product: product2, quantity: 1) }
        let!(:item3) { ShoppingListItem.create!(shopping_list: shopping_list, product: product3, quantity: 1, notes: 'Whole wheat') }
        
        let(:id) { shopping_list.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data).to include('shopping_list_id', 'store_name', 'optimized_items')
          expect(data['shopping_list_id']).to eq(shopping_list.id)
          expect(data['store_name']).to eq('Test Store')
          expect(data['optimized_items']).to be_a(Array)
          expect(data['optimized_items'].length).to eq(3)
          
          # Verify items are sorted by aisle (1, 2, 4)
          aisles = data['optimized_items'].map { |item| item['aisle'] }
          expect(aisles).to eq(['1', '2', '4'])
        end
      end

      response '404', 'shopping list not found' do
        let!(:user) { User.create!(email: 'optimized2@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let(:id) { 99999 }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(404)
          expect(data['error']).to eq('Shopping list not found')
        end
      end
    end
  end
end