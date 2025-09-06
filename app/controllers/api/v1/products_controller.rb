class Api::V1::ProductsController < ApplicationController
  before_action :authorize_user

  # GET /api/v1/products
  # Optionally filtered by ?store_id=1
  def index
    if index_params[:store_id]
      store = Store.find_by(id: index_params[:store_id])
      return render json: { error: "Store not found" }, status: :not_found unless store

      store_products = store.store_products.includes(:product)
      render json: store_products.map { |sp| store_product_response(sp) }, status: :ok
    else
      products = Product.all
      render json: products.map { |p| product_response(p) }, status: :ok
    end
  end

  def index_params
    params.permit(:store_id)
  end

  # GET /api/v1/products/:id
  def show
  product = Product.find_by(id: show_params[:id])
    if product
      render json: product_response(product), status: :ok
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  private

  def product_response(product)
    {
      id: product.id,
      name: product.name,
      category: product.category,
      brand: product.brand,
      image_url: product.image_url
    }
  end

  def store_product_response(store_product)
    {
      id: store_product.product.id,
      name: store_product.product.name,
      category: store_product.product.category,
      brand: store_product.product.brand,
      image_url: store_product.product.image_url,
      aisle: store_product.aisle,
      price: store_product.price,
      location: store_product.location,
      store_id: store_product.store_id
    }
  end

  def show_params
    params.permit(:id)
  end
end
