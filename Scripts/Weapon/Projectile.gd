## An object that can be fired.
class_name Projectile
extends CharacterBody3D

@export_category("Base Info")
@export var speed: float = 20.0
@export var gravity_strength: float = 0

@export var is_homing: bool = false
var homing_target: Node3D   = null

## How long this projectile is allowed to live before dying.
@export var max_lifetime: float = 10.0
var curr_lifetime: float = 0.0

@export var arc: bool = false
@export var damage: int = 1

@export_category("Explosion Related")
## Does this explode when it hits? If so, what explosion should it spawn?
@export var explodes_on_impact: bool = false
@export var explosion_scene: PackedScene

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	set_as_top_level( true )

func _physics_process(delta: float) -> void:
	
	if arc == false:
		velocity    = direction * speed
		velocity.y -= gravity_strength * delta
	else:
		velocity += Vector3.DOWN * gravity_strength * delta
	var collision = move_and_collide( velocity * delta )
	if collision:
		
		on_hit( collision )
	
	tick_lifetime( delta )

func tick_lifetime(delta: float) -> void:
	# This projectile has lived long enough, destroy it.
	curr_lifetime += delta
	if curr_lifetime > max_lifetime:
		on_timeout()

func on_hit(collision: KinematicCollision3D) -> void:
	if explodes_on_impact == true:
		var explosion: Explosion = explosion_scene.instantiate()
		get_tree().get_root().add_child(explosion)
		explosion.global_position = global_position
		explosion.set_damage( damage )
		# TODO: Set the faction in case this projectile does not hurt comrades.
	else:
		var collider = collision.get_collider()
		if collider and collider.has_node("CharacterStats"):
			var my_faction: FactionOwner = get_node("FactionOwner")
			# Don't hurt someone if they are on the same side
			if my_faction.get_faction() != collider.get_node("FactionOwner").get_faction():
			
				var cs: CharacterStats = collider.get_node("CharacterStats")
				cs.take_damage( damage )
			
	queue_free()

func on_timeout() -> void:
	if explodes_on_impact == true:
		var explosion: Explosion = explosion_scene.instantiate()
		get_tree().get_root().add_child(explosion)
		explosion.global_position = global_position
		explosion.set_damage( damage )
	queue_free()

func explode() -> void:
	var explosion: Explosion = explosion_scene.instantiate()

## Set where this projectile should go towards.
func set_direction(new_dir: Vector3) -> void:
	if arc == true:
		velocity = new_dir
	else:
		direction = new_dir

## For when something should override this projectile's damage.
func set_damage(new_damage: int) -> void:
	damage = new_damage
