## Component for a units that attack with equipment.
class_name EquipmentBasedAttacker
extends Attacker

## The weapon the character currently has equipped.
@export var curr_weapon: Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	if curr_weapon.is_melee == true:
		curr_weapon.melee_hitbox.body_entered.connect( on_melee_weapon_hitbox_entered )

func attack(target_to_attack: Node3D) -> void:
	var target_stats: CharacterStats = target_to_attack.get_node("CharacterStats")
	
	var my_faction: FactionOwner = get_parent().get_node("FactionOwner")
	if curr_weapon.is_melee == false:
		# TODO: Safety check for hitscans and projectiles
		var p: Projectile = curr_weapon.projectile_to_fire.instantiate()
		get_parent().add_child( p )
		
		p.get_node("FactionOwner").set_faction( my_faction.get_faction() )
		var direction: Vector3 = (target_to_attack.global_position - get_parent().global_position).normalized()
		p.set_damage( get_power() )
		p.set_direction( direction )
		p.global_position = curr_weapon.fire_position.global_position
	
	else:
		# TODO: Testing melee. A more elegant and dynamic way should be done.
		var anim_player: AnimationPlayer = curr_weapon.get_node("AnimationPlayer")
		anim_player.play("Great Sword Slam")
	
	curr_activation_time = 0.0

func get_power() -> int:
	var power: int = 0
	power = stats.get_physical_power()
	return power

## Called when the melee hitbox is activated.
func on_melee_weapon_hitbox_entered(body: Node3D) -> void:
	if body.has_node("FactionOwner"):
		# Do not hurt friends.
		var my_faction: FactionOwner = get_parent().get_node("FactionOwner")
		if my_faction.get_faction() == body.get_node("FactionOwner").get_faction():
			return

		var power = get_power()
		var target_stats: CharacterStats = body.get_node("CharacterStats")
		target_stats.take_damage( power )
		print("EquipmentBasedAttacker :: %s is taking %s damage." % [body.name, power])
