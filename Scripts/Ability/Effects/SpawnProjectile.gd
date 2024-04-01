## An effect that is responsible for spawning a projectile.
class_name SpawnProjectile
extends AbilityEffect

## The projectile this ability should spawn.
@export var projectile_to_spawn: PackedScene

## Should this projectile be fired in an arc?
@export var arcs: bool = false

## If this projectile must be fired in an arc, do so.
@export var curve_height: float = 5.0

func execute(activator: Node3D, target: Node3D, target_pos: Vector3) -> void:
	# Create the projectile and see how it should move.
	var p: Projectile = projectile_to_spawn.instantiate()
	var direction: Vector3 = Vector3.ZERO
	if arcs == true:
		direction = calculate_arc(
			activator.global_position,
			target_pos,
			p.speed,
			p.gravity_strength
		)
	
	else:
		direction = (target_pos - activator.global_position).normalized()
	
	# Set the proper faction
	var activator_faction: FactionOwner = activator.get_node("FactionOwner")
	p.get_node("FactionOwner").set_faction( activator_faction.get_faction() )
	
	activator.add_child( p )
	p.global_position = activator.global_position + Vector3.UP
	p.add_collision_exception_with( activator ) # Don't collide with the activator
	p.set_direction( direction )

## Calculates the arc for the projectile.
## Gotten from the Godot Roboblast project.
func calculate_arc(initial_pos: Vector3, target_pos: Vector3, speed: float, gravity: float):
	var peak_height:     float = max(target_pos.y + curve_height, initial_pos.y + curve_height)
	var motion_up:       float = peak_height
	var time_going_up:   float = sqrt(2.0 * motion_up / gravity)
	var motion_down:     float = target_pos.y - peak_height
	var time_going_down: float = sqrt(-2.0 * motion_down / gravity)
	var time_to_land:    float = time_going_up + time_going_down
	
	var target_xz_plane:  Vector3 = Vector3(target_pos.x, 0.0, target_pos.z)
	var start_xz_plane:   Vector3 = Vector3(initial_pos.x, 0.0, initial_pos.z)
	var forward_velocity: Vector3 = (target_xz_plane - start_xz_plane) / time_to_land
	var velocity_up:              = sqrt(2.0 * gravity * motion_up)
	var arc:              Vector3 = Vector3.UP * velocity_up + forward_velocity
	return arc
