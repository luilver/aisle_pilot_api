require 'swagger_helper'

RSpec.describe 'Stores zip search', type: :request do
  path '/api/v1/stores' do
    get 'List stores filtered by zip code' do
      tags 'Stores'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :zip_code, in: :query, schema: { type: :string }

      response '200', 'stores found by zip code' do
        let!(:user) { User.create!(email: 'ziptest@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store1) { Store.create!(name: 'Walmart Salt Lake City', location: 'Salt Lake City, UT 84101') }
        let!(:store2) { Store.create!(name: 'Walmart Austin', location: 'Austin, TX 78701') }
        let!(:store3) { Store.create!(name: 'Walmart Miami', location: 'Miami, FL 33101') }
        let(:zip_code) { '84101' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data).to be_a(Array)
          expect(data.length).to eq(1)
          expect(data.first['name']).to eq('Walmart Salt Lake City')
        end
      end

      response '200', 'no stores found message' do
        let!(:user) { User.create!(email: 'ziptest2@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) do
          secret = Rails.application.credentials.jwt_secret.presence || ENV['JWT_SECRET']
          token = JWT.encode({ user_id: user.id }, secret, 'HS256')
          "Bearer #{token}"
        end
        let!(:store1) { Store.create!(name: 'Walmart Salt Lake City', location: 'Salt Lake City, UT 84101') }
        let(:zip_code) { '99999' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.code.to_i).to eq(200)
          expect(data['message']).to include('No stores found for zip code 99999')
        end
      end
    end
  end
end
