class ProductsController < ApplicationController
  def index
    @products = Product.includes(:product_details).limit(20)
  end

  def show
    @product = Product.includes(product_details: { book_authors: :author }).find_by(slug: params[:slug])
  end
end
