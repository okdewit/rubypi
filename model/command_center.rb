require_relative 'planetary_building.rb'
require_relative 'unrestricted_storage.rb'

class CommandCenter < PlanetaryBuilding
  
  include UnrestrictedStorage
  
  attr_reader :upgrade_level
  
  LEVEL_TO_PG_TABLE = {"0" => 6000,
                       "1" => 9000,
                       "2" => 12000,
                       "3" => 15000,
                       "4" => 17000,
                       "5" => 19000 }
  
  LEVEL_TO_CPU_TABLE = {"0" => 1675,
                        "1" => 7057,
                        "2" => 12136,
                        "3" => 17215,
                        "4" => 21315,
                        "5" => 25415 }
  
  LEVEL_TO_ISK_TABLE = {"0" => 90000,
                        "1" => 670000,
                        "2" => 1600000,
                        "3" => 2800000,
                        "4" => 4300000,
                        "5" => 6400000 }
  
  UPGRADE_LEVEL = 0
  POWERGRID_USAGE = 0
  CPU_USAGE = 0
  STORAGE_VOLUME = 500.0
  
  def initialize
	@upgrade_level = UPGRADE_LEVEL
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = self.powergrid_provided
	@cpu_provided = self.cpu_provided
	@isk_cost = self.isk_cost
	
	return self
  end
  
  def name 
	return "Command Center"
  end
  
  def powergrid_provided
	return LEVEL_TO_PG_TABLE["#{@upgrade_level}"]
  end
  
  def cpu_provided
	return LEVEL_TO_CPU_TABLE["#{@upgrade_level}"]
  end
  
  def isk_cost
	return LEVEL_TO_ISK_TABLE["#{@upgrade_level}"]
  end
  
  def storage_volume
	return STORAGE_VOLUME
  end
  
  def increase_level
	if (@upgrade_level == 5)
	  # Do nothing.
	else
	  @upgrade_level += 1
	  
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def decrease_level
	if (@upgrade_level == 0)
	  # Do nothing.
	else
	  @upgrade_level -= 1
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def set_level(level)
	if (level.between?(0, 5))
	  # Ok, it's a valid level.
	  # Let's make sure we're not setting something we already have.
	  if (level == @upgrade_level)
		# No change in the value.
		return
	  end
	  
	  @upgrade_level = level
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	else
	  # Invalid level passed.
	  raise ArgumentError, "Passed in level must be between 0 and 5."
	end
  end
end
