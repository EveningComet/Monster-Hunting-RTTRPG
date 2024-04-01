## For abilities that only care about the user activating the ability.
class_name SelfTargetingLogic
extends AbilityTargetingLogic

## Return the activator and target using the person that activated the ability.
func get_targets(activator: Node3D, target_pos: Vector3) -> Dictionary:
	var dictionary_to_return: Dictionary = {}
	dictionary_to_return["activator"]  = activator
	dictionary_to_return["targets"]    = [activator]
	dictionary_to_return["target_pos"] = activator.global_position
	return dictionary_to_return
