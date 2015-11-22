#!/usr/bin/env ruby
require File.expand_path('../business', __FILE__)

# Create the warehouse
puts "warehouse opening..."
@warehouse =  Warehouse.new
@warehouse.get_stock_info

# Fill the warehouse with some products
puts "filling warehouse..."
@warehouse.add(:pear, 50)
@warehouse.add(:apple, 25)
puts @warehouse.get_stock_info

# Create an order
order = Order.new :pear, 50
puts "order asks for..."
puts order.get_order_info

# Perform the purchase
order.fill @warehouse

# Check the purchase went OK
puts "was order filled?"
puts order.filled?
puts "warehouse current stock..."
puts @warehouse.get_stock_info
