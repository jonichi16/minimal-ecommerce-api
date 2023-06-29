class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_and_set_admin
  before_action :set_category, only: %i[show update destroy]

  def index
    @categories = Category.all

    render json: CategorySerializer.new(@categories).serializable_hash[:data], status: :ok
  end

  def show
    render json: {
      data: CategorySerializer.new(@category).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      render json: {
        message: "Category created successfully",
        data: CategorySerializer.new(@category).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        error: "Something went wrong"
      }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: {
        message: "Category edited successfully",
        data: CategorySerializer.new(@category).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        error: "Something went wrong"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
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

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Category Not Found"
    }, status: :not_found
  end
end
