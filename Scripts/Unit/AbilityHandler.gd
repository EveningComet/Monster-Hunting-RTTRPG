## Stores and helps execute abilities for units.
class_name AbilityHandler
extends Node

## Fired when an ability has been performed.
signal ability_executed( index: int )

@export var abilities_to_instance: Array[Ability]

## The abilities this unit can execute.
var abilities: Array[AbilitySlotData]

## Are we currently performing an ability?
var is_performing_ability: bool = false

## The stats of the activator.
var stats: CharacterStats

func _ready() -> void:
	stats = get_parent().get_node("CharacterStats")
	initialize_abilities()
	
func initialize_abilities() -> void:
	for a in abilities_to_instance:
		var a_slot: AbilitySlotData = AbilitySlotData.new()
		a_slot.setup_ability_instance( a )
		abilities.append( a_slot )

func _physics_process(delta: float) -> void:
	handle_cooldowns( delta )

## Access the stored abilities.
func get_abilities() -> Array[AbilitySlotData]:
	return abilities

## Loop through our abilities and tick their cooldowns.
func handle_cooldowns(delta: float) -> void:
	for a in abilities:
		if a != null:
			a.tick( delta )

# Execute the passed ability slot data ability and perform the move.
func execute_ability(asd: AbilitySlotData, target: Node3D, target_pos: Vector3) -> void:
	if abilities.has(asd):
		# TODO: Make sure the activator has enough of the special stat here?
		
		var index: int = abilities.find(asd)
		abilities[index].get_ability().execute(
			get_parent(),
			target,
			target_pos
		)
		
		# Fire the relevant event
		ability_executed.emit( index )
		
		# Reset the cooldown
		asd.reset_cooldown()
		
		print("AbilityHandler :: %s is activating an ability." % get_parent().name)
