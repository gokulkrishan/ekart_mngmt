class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_request
    def index
      products =Product.page(params[:page]).per_page(2)
      render json: products, status: 200
    end

    def show
      a = Product.joins(:categories).all.select("products.id,products.style_name as product_style_name,categories.price as category_price,categories.qty as category_qty,categories.colour as category_colour")
      render json: a, status: 200
    end

    def joins
      a = Product.joins(:categories).all.select("products.id,products.style_name")
      render json: a, status: 200
    end

    def list_like
      a = Product.joins(:categories).where("style_name LIKE ?", "%#{params[:search]}%").select("products.id,products.style_name,categories.price,qty")
      render json: a, status: 200
    end

    def create
        product = Product.new(
          prd_type: p_params[:prd_type],
          style_name: p_params[:style_name]
        )
      if product.save
        render json: product, status: 200
      else
        render json: product.errors.details, status: 422
      end
    end

    def update
        product = Product.find_by(id: params[:id])
      if product
        product.update(prd_type: params[:prd_type], style_name: params[:style_name])
        render json: "product updated successfully",status: 200
      else
        render json: {
          error: "product not found"
        }, status: 404
      end
    end
  
    def destroy
        product = Product.find_by(id: params[:id])
      if product
        product.destroy
        render json: "product has been deleted", status: 200
      else
        render json: "product not found", status: 404
      end
    end
  
    def p_params
      params.require(:product)
    end

end
