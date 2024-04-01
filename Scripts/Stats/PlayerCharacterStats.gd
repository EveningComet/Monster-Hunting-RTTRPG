## Variant of the stats component for the player's characters.
class_name PlayerCharacterStats
extends CharacterStats

func die() -> void:
	unit_died.emit( self )
	
	# Turn off the components until we're all good.
	

## Get the character back up.
func revive() -> void:
	pass

## Called when a player character has gained enough experience.
## Difference from the base function is that this will pull from the character's
## job.
func level_up() -> void:
	# Raise the level and increase the experience requirement
	current_level += 1
	experience_required = get_experience_required(
		current_level
	)
	
	# TODO: Boost the stats based on the character's job/class.
	
	# Fire an event to tell anything about the stats change
	stat_changed.emit( self )
	
	print("PlayerCharacterStats :: %s has leveled up!" % get_parent().name)
