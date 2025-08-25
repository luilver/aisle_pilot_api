module Api
  module V1
    class ShoppingListsController < ApplicationController
      before_action :authorize_user
  before_action :set_shopping_list, only: [ :show, :update, :destroy ]

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
        head :no_content
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
