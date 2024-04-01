## An object that will move a character overtime. It will destroy itself
## after reaching its destination or the max allowed time has passed.
## Mainly used by abilities that move overtime.
class_name TempMover
extends Node

## How long, in seconds, before this node will destroy itself.
@export var max_lifetime: float = 10.0
var curr_lifetime:        float = 0.0

## This is for when this should dynamically move towards a target.
var target_obj:         Node3D  = null
var using_target_obj:   bool    = false

## Used for when this should just move towards a static destination.
var target_destination: Vector3 = Vector3.ZERO
var using_target_dest:  Vector3 = Vector3.ZERO

## Character body used for movement, if this is the parent node.
var character_body: CharacterBody3D

# Using an initialization method due to potential race conditions with _ready().
## Activate this temporary mover.
func activate(target: Node3D, target_pos: Vector3, use_target_obj: bool = false) -> void:
	character_body = get_parent()
	
	target_destination = target_pos
	
	# Disable the character's mover component, if they have one
	disable_regular_mover()

func _physics_process(delta: float) -> void:
	
	# Enough time has passed, so die
	curr_lifetime += delta
	if curr_lifetime > max_lifetime:
		enable_regular_mover()
		
		queue_free()

func enable_regular_mover() -> void:
	if character_body.has_node("Mover") == true:
		var mover: Mover = character_body.get_node("Mover")
		mover.set_physics_process( true )

func disable_regular_mover() -> void:
	if character_body.has_node("Mover") == true:
		var mover: Mover = character_body.get_node("Mover")
		mover.stop()
		mover.set_physics_process( false )
