## Damages things within an area.
class_name Explosion
extends Area3D
# TODO: Turn this into a general damaging aoe.

## Does this aoe damage everything inside it?
@export var damages_everyone: bool = true

## Used by damaging aoes that do not hurt comrades.
@export var my_faction: FactionOwner

## How much damage this deals.
@export var damage: int = 5

@export var particles: GPUParticles3D
@onready var timer: Timer = $Timer

func _ready() -> void:
	particles.emitting = true
	body_entered.connect( on_body_entered )
	timer.timeout.connect( on_timer_timeout )

## When something such as an ability should override the damage this deals.
func set_damage(new_damage: int) -> void:
	damage = new_damage

func on_body_entered(body: Node3D) -> void:
	if body.has_node("CharacterStats"):
		var cs: CharacterStats = body.get_node("CharacterStats")
		cs.take_damage( damage )

func on_timer_timeout() -> void:
	queue_free()
