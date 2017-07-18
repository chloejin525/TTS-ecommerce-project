class CartController < ApplicationController
  before_action :authenticate_user! #, except: [:add_to_cart, :view_cart]
 
  def add_to_cart
    if LineItem.count == 0 && 
      @order = Order.create(user_id: current_user.id, subtotal: 0)
    end 
    line_item = LineItem.new(product_id: params[:product_id], quantity: params[:quantity])
      if LineItem.pluck(:product_id).include?(line_item.product_id)
        @existing_line_item = LineItem.find_by(product_id: line_item.product_id)
        @existing_line_item.update(quantity: (@existing_line_item.quantity + line_item.quantity))
        @existing_line_item.update(line_item_total: (@existing_line_item.quantity * @existing_line_item.product.price))
      else
        line_item.save
        line_item.update(line_item_total: (line_item.quantity * line_item.product.price))
      end

  	#if it cannot find the back, it will go to the root
  	redirect_back(fallback_location: root_path)
  end

  def view_cart
    @line_items = LineItem.all
  end

  def view_order
    @orders = Order.where(user_id: current_user.id).reverse
  end

  def checkout
  	line_items = LineItem.all
    @order = Order.where(user_id: current_user.id).last
    line_items.each do |line_item|
    	line_item.product.update(quantity: (line_item.product.quantity - line_item.quantity))
    	@order.order_items[line_item.product_id] = line_item.quantity 
    	@order.subtotal += line_item.line_item_total
    end
  	@order.save

  	@order.update(sales_tax: (@order.subtotal * 0.08))
  	@order.update(grand_total: (@order.sales_tax + @order.subtotal))
    @order.update(status: "Submitted")
  	line_items.destroy_all
  end
end
