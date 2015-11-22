#!/usr/bin/env ruby
require "minitest/autorun"
require File.expand_path('../business', __FILE__)

# TDD STATE APPROACH:
# Follow these 4 steps to check a SUT (System Under Test) object:
#
# 1. Setup SUT and any collaborator(s) if needed
# 2. Exercise the SUT action under test
# 3. Verify the final SUT state and any final collaborator(s) state(s) if needed
# 4. Tear down, autodone by the garbage collector system
#

# SUT: order
# Collaborator: warehouse
class OrderStateTester <  Minitest::Test

  # Setup collaborator
  def setup
    @warehouse =  Warehouse.new
    @warehouse.add(:pear, 50)
    @warehouse.add(:apple, 25)
  end

  # If there's enough products in stock the order can be performed,
  # that means that the order can be filled and the warehouse products
  # asked by the order are taken.
  #
  def test_order_is_filled_if_enough_pears_in_warehouse
    # Setup SUT
    order = Order.new(:pear, 50)
    # Exercise
    order.fill(@warehouse)
    # Verify SUT final state
    assert(order.filled?)
    # Verify collaborator final state
    assert_equal(0, @warehouse.get_inventory(:pear))
  end

  # If there's not enough products in stock the order can't be performed,
  # that means that the order can't be filled and the warehouse products
  # remain there.
  #
  def test_order_does_not_remove_if_not_enough_pears
    # Setup SUT
    order = Order.new(:pear, 51)
    # Exercise
    order.fill(@warehouse)
    # Verify SUT final state
    assert_not order.filled?
    # Verify collaborator final state
    assert_equal(50, @warehouse.get_inventory(:pear))
  end

  # Repeat the tests with apples...
  def test_order_is_filled_if_enough_apples_in_warehouse
    order = Order.new(:apple, 15)
    order.fill(@warehouse)
    assert(order.filled?)
    assert_equal(10, @warehouse.get_inventory(:apple))
  end

  def test_order_does_not_remove_if_not_enough_apples
    order = Order.new(:apple, 35)
    order.fill(@warehouse)
    assert_not order.filled?
    assert_equal(25, @warehouse.get_inventory(:apple))
  end

  # Custom assertion:
  # assert_not verifies something is false
  #
  def assert_not bool
    assert !bool
  end
end
