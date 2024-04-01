## Describes how an ability gets its targets to activate.
class_name AbilityTargetingLogic
extends Resource

## Base function for getting the targets.
func get_targets(activator: Node3D, target_pos: Vector3) -> Dictionary:
	var dictionary_to_return: Dictionary = {}
	dictionary_to_return["activator"]  = activator
	dictionary_to_return["targets"]    = []
	dictionary_to_return["target_pos"] = Vector3.ZERO
	return dictionary_to_return
