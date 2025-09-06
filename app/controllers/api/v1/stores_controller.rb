class Api::V1::StoresController < ApplicationController
  before_action :authorize_user

  # GET /api/v1/stores
  # Optionally filtered by ?zip_code=12345
  def index
    if index_params[:zip_code]
      stores = Store.where("location LIKE ?", "%#{index_params[:zip_code]}%")
      if stores.empty?
        return render json: { message: "No stores found for zip code #{index_params[:zip_code]}" }, status: :ok
      end
    else
      stores = Store.all
    end
    
    render json: stores.map { |store| store_response(store) }, status: :ok
  end

  def index_params
    params.permit(:zip_code)
  end

  # GET /api/v1/stores/:id
  def show
    store = Store.find_by(id: params[:id])
    if store
      render json: store_response(store), status: :ok
    else
      render json: { error: "Store not found" }, status: :not_found
    end
  end

  private

  def store_response(store)
    {
      id: store.id,
      name: store.name,
      location: store.location,
      layout: store.layout,
      created_at: store.created_at,
      updated_at: store.updated_at
    }
  end
end
