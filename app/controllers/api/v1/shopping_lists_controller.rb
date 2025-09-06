module Api
  module V1
    class ShoppingListsController < ApplicationController
      before_action :authorize_user
      before_action :set_shopping_list, only: [:show, :update, :destroy]

      # GET /api/v1/shopping_lists
      def index
        @shopping_lists = current_user.shopping_lists
        render json: @shopping_lists
      end

      # GET /api/v1/shopping_lists/:id
      def show
        render json: @shopping_list
      end

      # POST /api/v1/shopping_lists
      def create
        @shopping_list = current_user.shopping_lists.build(shopping_list_params)

        if @shopping_list.save
          render json: @shopping_list, status: :created
        else
          render json: { errors: @shopping_list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/shopping_lists/:id
      def update
        if @shopping_list.update(shopping_list_params)
          render json: @shopping_list
        else
          render json: { errors: @shopping_list.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/shopping_lists/:id
      def destroy
      @shopping_list.destroy
      render json: { message: "Shopping lists deleted" }, status: :ok
      end

      # GET /api/v1/shopping_lists/:id/optimized_order
      def optimized_order
        @shopping_list = current_user.shopping_lists.find_by(id: params[:id])
        return render json: { error: "Shopping list not found" }, status: :not_found unless @shopping_list

        items_with_location = @shopping_list.shopping_list_items.includes(:product).map do |item|
          store_product = StoreProduct.find_by(store: @shopping_list.store, product: item.product)
          {
            id: item.id,
            product_name: item.product.name,
            quantity: item.quantity,
            notes: item.notes,
            aisle: store_product&.aisle || "Unknown",
            location: store_product&.location || {},
            category: item.product.category
          }
        end

        # Sort by aisle number for optimal shopping order
        optimized_items = items_with_location.sort_by do |item|
          aisle_number = item[:aisle].to_i
          aisle_number == 0 ? Float::INFINITY : aisle_number
        end

        render json: {
          shopping_list_id: @shopping_list.id,
          store_name: @shopping_list.store.name,
          optimized_items: optimized_items
        }, status: :ok
      end

      private

      def set_shopping_list
        @shopping_list = current_user.shopping_lists.find_by(id: params[:id])
        render json: { error: "Not Found" }, status: :not_found unless @shopping_list
      end

      def shopping_list_params
        params.require(:shopping_list).permit(:name, :store_id, :notes)
      end
    end
  end
end
