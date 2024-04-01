## Component for units that attack solely based on stats.
class_name StatsBasedAttacker
extends Attacker

## The base damage this attacker can do.
@export var base_damage: int = 5

## The hitbox component for this character.
@export var hitbox: Area3D

# TODO: This is for testing. Find a better way.
@export var animation_player: AnimationPlayer

func _ready() -> void:
	super()
	
	# TODO: Melee default attacker and ranged default attacker.
	hitbox.body_entered.connect( on_hitbox_entered )

func attack(target_to_attack: Node3D) -> void:
	animation_player.play("attack_1")
	curr_activation_time = 0.0

func get_power() -> int:
	var power: int = 0
	power = stats.get_physical_power()
	return power

func on_hitbox_entered(body: Node3D) -> void:
	if body.has_node("CharacterStats"):
		# Do not hurt yourself or friends
		var my_faction: FactionOwner = get_parent().get_node("FactionOwner")
		var t_faction:  FactionOwner = body.get_node("FactionOwner")
		if my_faction.get_faction() == t_faction.get_faction():
			return
		
		var power: int = get_power()
		var cs: CharacterStats = body.get_node("CharacterStats")
		cs.take_damage( power )
		print("StatsBasedAttacker :: %s is going to possibly take %s damage." % [body.name, power])
