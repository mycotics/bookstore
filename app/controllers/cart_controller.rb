class CartController < ApplicationController
  before_action :add_session


  def index
    session_token = session['session']
    session_data = session_token ? JwtService.decode(session_token): {}
    @data = {"session_data": session_data}

    id_list = session_data["cart"].keys
    products = Product.includes(:product_details).where(id: id_list)
    @products = products
    @cart = session_data["cart"]
    @total_price = 0
    @products.each do |product|
      @total_price += product.price * session_data["cart"][product.id.to_s]
    end
  end

  def add_to_cart

    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    session_token = session['session']

    session_data = session_token ? JwtService.decode(session_token): {}
    session_data[:cart] ||= {}

    if quantity == 0
      session_data[:cart].delete(product_id)
      puts 'delete'
    else
      session_data[:cart][product_id] ||= 0
      session_data[:cart][product_id] = quantity
    end


    session_token = JwtService.encode(session_data)
    session['session'] = session_token

    redirect_to cart_path

  end

  def add_session
    session_token = session['session']
    session_data = session_token ? JwtService.decode(session_token): {}
    session_data[:session_id] ||= SecureRandom.hex
    session_data[:cart] ||= {}
    session_token = JwtService.encode(session_data)
    session['session'] = session_token
  end

  def checkout
    @test = 'dfdfdf'

  end


end
