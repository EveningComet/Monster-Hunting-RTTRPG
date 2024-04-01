class_name StatTypes

enum stat_types {
	# Attributes
	Fitness,              # For physical damage, health, etc.
	Dexterity,            # For other things
	Will,                 # For mind, special points, etc.
	
	# Vitals
	MaxHP,                # Max hit points
	CurrentHP,            # Current hit points
	MaxSP,                # Our max mana/stamina/etc.
	CurrentSP,            # Our current mana/stamina/etc.
	
	# Other stats
	Defense,              # Reduces physical damage
	ActionRate            # Our base attack/action rate, in seconds
}
