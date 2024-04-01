## An effect that pulls a character towards the activator.
class_name PullTowards
extends AbilityEffect

## Prefab of the scene that will hold the grab and puller object.
@export var grab_and_puller_scene: PackedScene

func execute(activator: Node3D, target: Node3D, target_pos: Vector3) -> void:
	# Spawn the thing that will be used to grab and pull.
	var gap: GrabAndPuller = grab_and_puller_scene.instantiate()
	activator.add_child(gap)
	gap.global_position = activator.global_position + Vector3.UP
	
	# Set the proper faction
	var activator_faction: FactionOwner = activator.get_node("FactionOwner")
	gap.get_node("FactionOwner").set_faction( activator_faction.get_faction() )
	
	gap.set_activator( activator )
	gap.add_collision_exception_with( activator )
	var dir: Vector3 = (target_pos - activator.global_position).normalized()
	gap.set_direction( dir )
