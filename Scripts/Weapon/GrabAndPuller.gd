## A modified projectile that handles grabbing and pulling characters towards
## the activator.
class_name GrabAndPuller
extends Projectile

## How close to the activator should this get to before this should be considered
## done?
@export var target_dist: float = 2.0

var activator: Node3D
var pullee:    Node3D
var pullee_original_parent: Node3D

var has_pullee: bool = false

func _physics_process(delta: float) -> void:
	if has_pullee == true:
		var dist: float = global_position.distance_squared_to( activator.global_position )
		if dist < target_dist * target_dist:
			on_timeout()
			return
		
		direction = (activator.global_position - global_position).normalized()
		velocity  = direction * speed
		move_and_slide()
		tick_lifetime( delta )
	else:
		super( delta )

func on_hit(collision: KinematicCollision3D) -> void:
	var collider = collision.get_collider()
	if collider != null and collider.has_node("CharacterStats"):
		curr_lifetime = 0.0
		var new_dir: Vector3 = (collider.global_position - activator.global_position).normalized()
		var original_pos: Vector3 = collider.global_position
		pullee = collider
		pullee_original_parent = pullee.get_parent()
		pullee_original_parent.remove_child( pullee )
		add_child(pullee)
		pullee.global_position = original_pos + Vector3.UP
		
		set_direction( new_dir )
		has_pullee = true
		
		# If the thing we grabbed has a temp mover on, destroy it
		if collider.has_node("TempMover") == true:
			var t_mover: TempMover = collider.get_node("TempMover")
			t_mover.enable_regular_mover()
			t_mover.queue_free()
		
		# Disable the attacker component for the character being pulled
		if collider.has_node("Attacker") == true:
			pass
		
		# Check if the thing we connected to has a mover a component, so we can
		# disable it
		if collider.has_node("Mover") == true:
			var mover: Mover = collider.get_node("Mover")
			mover.stop()
			mover.set_physics_process( false )
		
		return
	
	# We did not find a valid target, so remove this
	queue_free()

func on_timeout() -> void:
	if pullee != null:
		remove_child(pullee)
		pullee_original_parent.add_child(pullee)
		pullee.global_position = global_position
		
		# Re-enable the mover component if there is one.
		if pullee.has_node("Mover"):
			var mover: Mover = pullee.get_node("Mover")
			mover.set_target_destination( pullee.position )
			mover.set_physics_process( true )
			
		# Re-enable the attacker component, if there is one
			
	super()

## Set the activator.
func set_activator(new_a: Node3D) -> void:
	activator = new_a

func set_direction(new_dir: Vector3) -> void:
	direction = new_dir
