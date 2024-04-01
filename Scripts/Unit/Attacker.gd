## Base component that can be attached to a unit that can perform a basic attack.
class_name Attacker
extends Node

## How far away from our target can we be before we can activate?
@export var range: float = 10.0

## Reference to the attached stats. Every character that can attack needs this.
@export var stats: CharacterStats

## How often do we perform our action?
@export var activation_rate: float = 0.5
var curr_activation_time:    float = 0.0

## The node of the thing we want to attack.
var target: Node3D = null

## Assists with getting a target.
var awareness_radius: AwarenessRadius

func _ready() -> void:
	awareness_radius = get_parent().get_node("AwarenessRadius")

func _physics_process(delta: float) -> void:
	# TODO: This should really not check for null every frame.
	if target == null:
		search_for_target()
		curr_activation_time = 0.0
		
	else:
		# We have gotten too far from the target, so bail
		if get_parent().position.distance_squared_to(target.position) > range * range:
			target = null
			curr_activation_time = 0.0
			return
		
		curr_activation_time += delta
		
		# Look towards the target
		# TODO: Smooth rotation
		get_parent().look_at(
			Vector3(target.position.x, get_parent().global_position.y, target.position.z),
			Vector3.UP
		)
		
		if curr_activation_time >= activation_rate:
			attack( target )

func attack(target_to_attack: Node3D) -> void:
	curr_activation_time = 0.0

func fire_projectile() -> void:
	pass

## Set the unit we want to attack.
func set_target(new_target: Node3D) -> void:
	target = new_target

func search_for_target() -> void:
	if awareness_radius.get_overlapping_bodies().size() > 0:
		var t
		
		# Find a suitable target
		for i in awareness_radius.get_overlapping_bodies():
			var potential_target = i
			
			# Do not attack friends
			if potential_target.has_node("FactionOwner") and potential_target.has_node("CharacterStats"):
				if potential_target.get_node("FactionOwner").get_faction() == get_parent().get_node("FactionOwner").get_faction():
					continue
				else:
					t = potential_target
					break
		
		# We found a suitable target
		if t:
			set_target( t )
