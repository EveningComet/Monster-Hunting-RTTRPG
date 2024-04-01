## An instance of an ability so that we can make copies of them.
class_name AbilityInstance

## The instance of the ability we want to copy.
@export var ability_to_instance: Ability

## How long before this instanced ability can activate?
var curr_cooldown: float = 0.0

## Setup the passed ability.
func setup_ability_instance(new_ability: Ability) -> void:
	ability_to_instance = new_ability
	curr_cooldown       = 0.0

## Update the ability.
func tick(delta: float) -> void:
	curr_cooldown -= delta
	curr_cooldown = max(curr_cooldown, 0) # Clamp so we don't go to some insane negative number
	# Tell anyone that cares about our cooldown.

func is_cooldown_finished() -> bool:
	return curr_cooldown <= 0

## Restart the cooldown. Usually called after an ability has been performed.
func reset_cooldown() -> void:
	curr_cooldown = ability_to_instance.base_cooldown

## Get the stored ability.
func get_ability() -> Ability:
	return ability_to_instance
