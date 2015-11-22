#!/usr/bin/env ruby
# TODO Add comments and explanations. It's hard to read

# Product class is a Struct 
# http://ruby-doc.org/core-2.2.3/Struct.html
class Product < Struct.new(:name, :quantity)
  def get_product_info
    "#{name}: #{quantity}\n"
  end
end

class Warehouse
  def initialize
    # OPTIMIZE Abstract out @pruducts hash implementation
    @products = {}
  end

  def add name, quantity
    if not @products[name].nil?
      @products[name].quantity += quantity
    else
      @products[name] = Product.new name, quantity
    end
  end

  def has_inventory? name, quantity
    @products[name].quantity >= quantity
  end

  def remove name, quantity
    @products[name].quantity -= quantity
  end

  def get name, quantity
    if has_inventory? name, quantity
      remove name, quantity
    end
  end

  ## OPTIMIZE I'm sure this can be done better...
  def get_stock_info
    info = ""
    @products.map do |_, product|
      info << product.get_product_info
    end
    info
  end

  def get_inventory name
    @products[name].quantity
  end
end

class Order
  def initialize name, quantity
    @product = Product.new name, quantity
    @filled = false
  end

  def filled?
    @filled
  end

  def fill warehouse
    if warehouse.has_inventory? @product.name, @product.quantity
      warehouse.get @product.name, @product.quantity
      @filled = true
    end
  end

  def get_order_info
    "#{@product.name}: #{@product.quantity}"
  end
end
