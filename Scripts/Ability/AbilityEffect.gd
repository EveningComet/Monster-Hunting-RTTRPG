## Base class that defines what an ability does.
class_name AbilityEffect
extends Resource

## Used for some effects that need to scale a number, such as damage or healing
## done.
@export var value_scale: float = 1.0

## Does this effect need to take the character's mind/will/spirit/magic stat into
## account, instead of the physical stat?
@export var uses_special_stat: bool = false

# TODO: Reformat paramaters to take a dictionary?w
## Some effects will need a target position, while other will target something directly
func execute(activator, target: Node3D, target_pos: Vector3) -> void:
	pass

func get_physical_power(activator: Node3D) -> int:
	var stats: CharacterStats = activator.get_node("CharacterStats")
	return stats.get_physical_power()

func get_special_power(activator: Node3D) -> int:
	return 1
