require "test/unit"

require_relative "../model/advanced_industrial_facility.rb"
require_relative "../model/schematic.rb"

class TestCaseAdvancedIndustrialFacility < Test::Unit::TestCase
  # Run once.
  def self.startup
	# Create some products and schematics for them.
	
	# Level 1 Products
	@@scum = Product.new("Scum", 1)
	@@villany = Product.new("Villany", 1)
	@@power_converters = Product.new("Power Converters", 1)
	@@friends = Product.new("Friends", 1)
	
	# Level 2 Products
	@@mos_eisley = Product.new("Mos Eisley", 2)
	@@tosche_station = Product.new("Tosche Station", 2)
	
	# Level 3 Products
	@@tattooine = Product.new("Tattooine", 3)
	@@dantooine = Product.new("Dantooine", 3)
	
	# Level 4 Products
	@@outer_rim = Product.new("Outer Rim", 4)
	
	# Level 2 Schematics
	@@mos_eisley_schematic = Schematic.new("Mos Eisley", 1, {"Scum" => 100, "Villany" => 100})
	@@tosche_station_schematic = Schematic.new("Tosche Station", 1, {"Power Converters" => 100, "Friends" => 5})
	
	# Level 3 Schematics
	@@tattooine_schematic = Schematic.new("Tattooine", 1, {"Mos Eisley" => 1, "Tosche Station" => 1})
	
	# Level 4 Schematics
	@@outer_rim_schematic = Schematic.new("Outer Rim", 1, {"Tattooine" => 1, "Dantooine" => 1})
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@scum)
	Product.delete(@@villany)
	Product.delete(@@power_converters)
	Product.delete(@@friends)
	Product.delete(@@mos_eisley)
	Product.delete(@@tosche_station)
	Product.delete(@@tattooine)
	Product.delete(@@dantooine)
	Product.delete(@@outer_rim)
	
	Schematic.delete(@@mos_eisley_schematic)
	Schematic.delete(@@tosche_station_schematic)
	Schematic.delete(@@tattooine_schematic)
	Schematic.delete(@@outer_rim_schematic)
  end
  
  # Run before every test.
  def setup
	@building = AdvancedIndustrialFacility.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(700, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(500, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(250000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Advanced Industrial Facility", @building.name)
  end
  
  def test_set_schematic
	@building.schematic_name = "Mos Eisley"
	assert_equal("Mos Eisley", @building.schematic_name)
	assert_equal(@@mos_eisley_schematic, @building.schematic)
  end
  
  def test_facility_errors_if_schematic_is_not_acceptable
	assert_equal(nil, @building.schematic_name)
	
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	
	# Should fail is name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_accepted_schematic_names
	# We should only accept schematics which have a p-level of 2 or 3.
	assert_equal(["Mos Eisley", "Tosche Station", "Tattooine"], @building.accepted_schematic_names)
  end
  
  def test_remove_schematic
	@building.schematic_name = "Tosche Station"
	assert_equal("Tosche Station", @building.schematic_name)
	assert_equal(@@tosche_station_schematic, @building.schematic)
	
	@building.schematic_name = nil
	assert_equal(nil, @building.schematic_name)
	assert_equal(nil, @building.schematic)
  end
  
  def test_schematic_refers_to_schematic_singleton
	@building.schematic_name = "Tosche Station"
	assert_equal(@building.schematic.object_id, @@tosche_station_schematic.object_id)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_basic_industrial_facility_is_observable
	assert_true(@building.is_a?(Observable), "Basic Industrial Facility did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_facility_notifies_observers_on_schematic_set
	@building.add_observer(self)
	
	@building.schematic_name = "Tattooine"
	
	assert_true(@was_notified_of_change, "Basic Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_notifies_observers_on_schematic_set_to_nil
	@building.schematic_name = "Tattooine"
	
	@building.add_observer(self)
	
	@building.schematic_name = nil
	
	assert_true(@was_notified_of_change, "Basic Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_does_not_notify_observers_on_schematic_set_failure
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	# Should fail is name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_facility_does_not_notify_observers_if_schematic_doesnt_change
	@building.schematic_name = "Tattooine"
	
	@building.add_observer(self)
	
	@building.schematic_name = "Tattooine"
	
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
end