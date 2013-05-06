require "test/unit"

require_relative "../model/command_center.rb"

class TestCaseCommandCenter < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@building = CommandCenter.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_default_level_is_zero
	assert_equal(0, @building.upgrade_level, "Default command center level is not zero.")
  end
  
  def test_level_can_be_increased
	@building.increase_level
	assert_equal(1, @building.upgrade_level, "Increasing a command center level did not work.")
  end
  
  def test_level_can_be_decreased
	@building.increase_level # 1
	
	@building.decrease_level
	assert_equal(0, @building.upgrade_level, "Decreasing a command center level did not work.")
  end
  
  def test_level_can_be_set
	@building.set_level(3)
	assert_equal(3, @building.upgrade_level, "Setting a command center level did not work.")
  end
  
  def test_level_cannot_be_increased_above_five
	@building.set_level(5)
	
	# Attempt to increase to 6.
	@building.increase_level
	assert_equal(5, @building.upgrade_level, "Increasing upgrade level 6 times does not max out at level 5.")
  end
  
  def test_level_cannot_be_decreased_below_zero
	@building.decrease_level
	assert_equal(0, @building.upgrade_level, "Decreasing the upgrade level from zero does not stop at zero.")
  end
  
  def test_level_cannot_be_set_below_zero
	# Make sure the class raises an argument error.
	assert_raise ArgumentError do
	  @building.set_level(-1)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(-12)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(-1236423254)
	end
	
	# Make sure the value didn't change.
	assert_equal(0, @building.upgrade_level, "Level should not be able to be set below zero.")
  end
  
  def test_level_cannot_be_set_above_five
	# Make sure the class raises an argument error.
	assert_raise ArgumentError do
	  @building.set_level(6)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(12)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(1236423254)
	end
	
	assert_equal(0, @building.upgrade_level, "Level should not be able to be set above five.")
  end
  
  def test_powergrid_provided_scales_with_level
	# CC Level 0
	assert_equal(6000, @building.powergrid_provided, "Level 0 CC powergrid is not accurate.")
	
	@building.increase_level # 1
	assert_equal(9000, @building.powergrid_provided, "Level 1 CC powergrid is not accurate.")
	
	@building.increase_level # 2
	assert_equal(12000, @building.powergrid_provided, "Level 2 CC powergrid is not accurate.")
	
	@building.increase_level # 3
	assert_equal(15000, @building.powergrid_provided, "Level 3 CC powergrid is not accurate.")
	
	@building.increase_level # 4
	assert_equal(17000, @building.powergrid_provided, "Level 4 CC powergrid is not accurate.")
	
	@building.increase_level # 5
	assert_equal(19000, @building.powergrid_provided, "Level 5 CC powergrid is not accurate.")
  end
  
  def test_cpu_provided_scales_with_level
	# CC Level 0
	assert_equal(1675, @building.cpu_provided, "Level 0 CC cpu is not accurate.")
	
	@building.increase_level # 1
	assert_equal(7057, @building.cpu_provided, "Level 1 CC cpu is not accurate.")
	
	@building.increase_level # 2
	assert_equal(12136, @building.cpu_provided, "Level 2 CC cpu is not accurate.")
	
	@building.increase_level # 3
	assert_equal(17215, @building.cpu_provided, "Level 3 CC cpu is not accurate.")
	
	@building.increase_level # 4
	assert_equal(21315, @building.cpu_provided, "Level 4 CC cpu is not accurate.")
	
	@building.increase_level # 5
	assert_equal(25415, @building.cpu_provided, "Level 5 CC cpu is not accurate.")
  end
  
  def test_powergrid_usage_value
	assert_equal(0, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(0, @building.cpu_usage)
  end
  
  def test_isk_cost_scales_with_level
	# CC Level 0
	assert_equal(90000.00, @building.isk_cost, "Level 0 CC isk cost is not accurate.")
	
	@building.increase_level # 1
	assert_equal(670000.00, @building.isk_cost, "Level 1 CC isk cost is not accurate.")
	
	@building.increase_level # 2
	assert_equal(1600000.00, @building.isk_cost, "Level 2 CC isk cost is not accurate.")
	
	@building.increase_level # 3
	assert_equal(2800000.00, @building.isk_cost, "Level 3 CC isk cost is not accurate.")
	
	@building.increase_level # 4
	assert_equal(4300000.00, @building.isk_cost, "Level 4 CC isk cost is not accurate.")
	
	@building.increase_level # 5
	assert_equal(6400000, @building.isk_cost, "Level 5 CC isk cost is not accurate.")
  end
  
  def test_name
	assert_equal("Command Center", @building.name)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_command_center_is_observable
	assert_true(@building.is_a?(Observable), "CC did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_command_center_notifies_observers_on_level_increase
	@building.add_observer(self)
	
	@building.increase_level
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_increase_fails
	@building.set_level(5)
	
	# Start watching @building.
	@building.add_observer(self)
	
	@building.increase_level
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_decrease
	# Have to be at an above-zero level to decrease properly.
	@building.set_level(3)
	
	# Start watching @building.
	@building.add_observer(self)
	
	@building.decrease_level
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_decrease_fails
	@building.add_observer(self)
	
	@building.decrease_level
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_set
	@building.add_observer(self)
	
	@building.set_level(3)
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_set_fails
	@building.set_level(3)
	
	@building.add_observer(self)
	
	@building.set_level(3)
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_default_num_observers_is_zero
	assert_equal(0, @building.count_observers)
  end
  
  # Storage / Observer tests.
  
  def test_command_center_notifies_observers_on_store_product
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_store_product_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_store_product_instance
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_store_product_instance_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_product_remove_all
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_product_remove_all_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_product_remove_quantity
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_product_remove_quantity_fails
	pend
  end
end