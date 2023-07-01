class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_and_set_admin
  before_action :set_category
  before_action :set_product, only: %i[show update destroy]

  def index
    @products = @category.products

    render json: ProductSerializer.new(@products).serializable_hash[:data], status: :ok
  end

  def show
    render json: {
      data: ProductSerializer.new(@product).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def create
    @product = @category.products.build(product_params)

    if @product.save
      render json: {
        message: "Product created successfully",
        data: ProductSerializer.new(@product).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        error: "Something went wrong"
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: {
        message: "Product edited successfully",
        data: ProductSerializer.new(@product).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        error: "Something went wrong"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {
        message: "Category deleted successfully"
      }, status: :ok
    else
      render json: {
        error: "Something went wrong"
      }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :quantity)
  end

  def set_category
    @category = Category.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Category Not Found"
    }, status: :not_found
  end

  def set_product
    @product = @category.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Category Not Found"
    }, status: :not_found
  end
end
