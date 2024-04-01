## Spawn a healing area of effect.
class_name SpawnHealingAOE
extends AbilityEffect

## The healing aura that this effect will spawn.
@export var healing_aura_scene: PackedScene

## Does this particular aoe effect to need spawn on a target?
@export var spawns_on_target: bool = false

func execute(activator: Node3D, target: Node3D, target_pos: Vector3) -> void:
	var healing_aura: HealingAura = healing_aura_scene.instantiate()
	var will_stat_data: Stat = activator.get_node("CharacterStats").get_stat(StatTypes.stat_types.Will)
	var will: int = will_stat_data.get_calculated_value()
	var healing_power: int = round( value_scale * float(will) )
	healing_aura.set_healing_power( healing_power )
	print("SpawnHealingAOE :: Healing power for the healing: %s" % healing_power)
	
	# Set the proper faction
	var activator_faction: FactionOwner = activator.get_node("FactionOwner")
	healing_aura.my_faction.set_faction( activator_faction.get_faction() )
	
	# Make the aura a child of the relevant node
	if spawns_on_target == true:
		target.add_child(healing_aura)
	else:
		activator.add_child( healing_aura )
