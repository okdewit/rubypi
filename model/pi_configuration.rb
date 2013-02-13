
require 'observer'

require_relative 'planet.rb'

class PIConfiguration
  
  include Observable
  
  attr_reader :planets
  attr_reader :product
  
  def initialize(planets = nil, product = nil)
	if (planets != nil)
	  planets.each do |planet|
		add_planet(planet)
	  end
	else
	  @planets = Array.new
	end
	
	@product = product
	
	return self
  end
  
  def add_planet(new_planet)
	new_planet.pi_configuration = self
	new_planet.add_observer(self)
	
	@planets << new_planet
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def remove_planet(planet_to_remove)
	# Lean on Array.delete.
	@planets.delete(planet_to_remove)
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  # Part of Observer.
  # Called when an observed object sends "changed".
  def update
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
end