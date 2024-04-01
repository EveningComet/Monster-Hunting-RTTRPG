## Component for units that can move.
class_name Mover
extends Node

## The component that uses Godot's built-in navigation system.
@export var navigation_agent: NavigationAgent3D = null

## How fast this unit moves.
# TODO: Put this in another thing?
@export var move_speed: float = 20.0

## How fast a specfied part will rotate towards it's movement direction. (Visual.)
@export var rot_speed: float = 10.0

@export var degree_offset: float = 180

## Where we're moving to.
var velocity: Vector3 = Vector3.ZERO

var parent: CharacterBody3D

## The place we will be moving to.
var target_pos: Vector3 = Vector3.ZERO

## Are we currently being moved by an ability?
var is_moving_by_ability: bool = false

## Used to avoid clustering.
var avoidance_weight: float = 0.1

func _ready() -> void:
	parent     = get_parent()
	target_pos = parent.global_transform.origin

func _physics_process(delta: float) -> void:
	
	# We have arrived at our destination, so this doesn't have to do anything else
	if navigation_agent.is_navigation_finished() == true:
		return
	
	# TODO: Don't update the path every frame.
	handle_move( delta )

## Movement for when the unit is not being moved by an ability.
func handle_move(delta: float) -> void:
	if is_moving_by_ability == true:
		return
	
	# Move towards our target
	velocity = Vector3.ZERO
	var dir = (navigation_agent.get_next_path_position() - parent.global_position).normalized()
	velocity = dir * move_speed
	parent.set_velocity(velocity)
	parent.move_and_slide()
	
	face_direction(dir, rot_speed, delta)

## Stop the movement.
func stop() -> void:
	set_target_destination(parent.global_position)

## Make this character look in the direction they are moving.
func face_direction(direction: Vector3, rotation_speed: float, delta: float) -> void:
	var modified_dir: Vector3 = Vector3(direction.x, parent.global_position.y, direction.z)
	parent.rotation.y = lerp_angle(
		parent.rotation.y,
		atan2(modified_dir.x, modified_dir.z) + deg_to_rad(degree_offset),
		rotation_speed * delta
	)

## Set our target destination.
func set_target_destination(new_destination: Vector3) -> void:
	target_pos = new_destination
	
	# Tell godot's navigation system where we want to move
	navigation_agent.set_target_position( target_pos )
