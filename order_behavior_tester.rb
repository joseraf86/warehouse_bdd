#!/usr/bin/env ruby
# Import Minitest support
require 'minitest/autorun'

# Import Mocha support within Minitest
gem 'mocha', '1.1.0'
require 'minitest/unit'
require 'mocha/mini_test'

require File.expand_path('../business', __FILE__)

# BDD APPROACH:
# Follow these 4 steps to check a SUT (System Under Test) object:
#
# 1. Setup SUT andd SUT expectations (Calls on other objects)
# 2. Exercise the SUT action under test
# 3. Verify the final SUT state and met expectations
# 4. Tear down, autodone by the garbage collector system
#

# SUT: order
# Mock: warehouse
class OrderInteractionTester <  Minitest::Test

  # Setup mock object
  def setup
    @warehouseMock = mock('warehouseMock')
  end

  # If there's enough products in stock the order can be performed,
  # that means that the order can be filled.
  #
  # Warehouse final state isn't checked because there's no a real
  # warehouse object to test. A warehouse mock is used instead.
  #
  # In a BDD test the focus is put on on testing SUT final state
  # and SUT calls on other objects. Collaborators objects final state
  # are beyond the scope of this unit test because they aren't the SUT.
  #
  # In BDD expectations about these calls are declared pefore exercising
  # the action and then checked to verify the expectations were met.
  #
  def test_order_is_filled_if_enough_pears_in_warehouse
    # Setup SUT
    order = Order.new(:pear, 50)
    # Declare expectations beforehand
    @warehouseMock.expects(:has_inventory?).with(:pear, 50).returns(true)
    @warehouseMock.expects(:get).with(:pear, 50)
    # Exercise
    order.fill(@warehouseMock)
    # Verify SUT final state 
    assert(order.filled?)
  end

  # If there's not enough products in stock the order can't be performed,
  # that means that the order can't be filled.
  #
  def test_order_does_not_remove_if_not_enough_pears
    # Setup SUT
    order = Order.new(:pear, 51)
    # Declare expectations beforehand
    @warehouseMock.expects(:has_inventory?).with(:pear, 51).returns(false)
    # Exercise
    order.fill(@warehouseMock)
    # Verify SUT final state
    assert_not(order.filled?)
  end

  # Repeat the tests with apples...
  def test_order_is_filled_if_enough_apples_in_warehouse
    order = Order.new(:apple, 15)
    @warehouseMock.expects(:has_inventory?).with(:apple, 15).returns(true)
    @warehouseMock.expects(:get).with(:apple, 15)
    order.fill(@warehouseMock)
    assert(order.filled?)
  end

  def test_order_does_not_remove_if_not_enough_apples
    order = Order.new(:apple, 35)

    # DESIGN OPTIMIZATION
    # Constraints are relaxed on this expectation
    # 
    # No arguments are specified because test_order_is_filled_if_enough_apples_in_warehouse
    # already checks that the parameters are passed to the warehouse, so this test don't need to
    # repeat that element. This eases the process of migrating tests if has_inventory? changes its
    # formal parameters.
    #
    @warehouseMock.expects(:has_inventory?).returns(false)
    order.fill(@warehouseMock)
    assert_not order.filled?
  end

  # Custom assertion: 
  # assert_not verifies something is false
  #
  def assert_not bool
    assert !bool
  end
end
