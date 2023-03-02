class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_request
  def index
    categories = Category.page(params[:page]).per_page(2)
    render json: categories , status: 200
  end

  def show
    category = Category.find_by(id: params[:id])
    if category
      render json: category, status: 200
    else
      render json: { error: "Category not found" }, status: 404
    end
  end
    
  def create
    category = Category.new(
      colour: c_params[:colour],
      price: c_params[:price],
      qty: c_params[:qty],
      product_id: c_params[:product_id]
    )
    if category.save
      render json: category, status: 200
    else
      render json: category.errors.details, status: 422
    end
  end

  def update
    category = Category.find_by(id: params[:id])
    if category
      category.update(colour: params[:colour], price: params[:price], qty: params[:qty], product_id: params[:product_id])
      render json: "category updated successfully", status: 200
    else
      render json: {
        error: "category not found"
      }, status: 404
    end
  end
  
  def destroy
    category = Category.find_by(id: params[:id])
    if category
      category.destroy
      render json: "category has been deleted", status: 200
    else
      render json: {
        error: "category not found"
      },status: 404
    end
  end
  
  def c_params
    params.require(:category)
  end
  
end
