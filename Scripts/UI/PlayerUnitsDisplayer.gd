## Handles displaying a player's units in clickable objects.
class_name PlayerUnitsDisplayer
extends Control

## The player we want to monitor. We will get their faction owner and
## display their relevant units.
@export var player_to_monitor: Node3D

## Reference to the unit ability displayer. We want to be able to display the
## abilities of the player's currently selected units.
@export var unit_ability_displayer: UnitAbilityDisplayer

## Prefab of the object we will use to quickly click on the units.
@export var clickable_prefab: PackedScene

@export var container: Container

## Connect a unit to a clickable button.
var unit_to_clickable: Dictionary = {}

## Reference to the player's selection controller. This is so we can easily
## display the abilities of selected units.
var selection_controller: SelectionController

func _ready() -> void:
	if player_to_monitor == null:
		emergency_output()
	else:
		setup_units_to_display()

func emergency_output() -> void:
	printerr(
		"PlayerUnitsDisplayer :: We were not properly given a player!"
	)

func setup_units_to_display() -> void:
	var faction: FactionOwner = player_to_monitor.get_node("FactionOwner")
	selection_controller = player_to_monitor.get_node("SelectionController")
	
	unit_ability_displayer.set_selection_controller( selection_controller )
	
	for unit in get_tree().get_nodes_in_group("Units"):
		
		# If the unit belongs to our player, add them to the displayable units
		if unit.get_node("FactionOwner").get_faction() == faction.get_faction():
			
			# Create the button and add them to our list
			var clickable: ClickableUnitButton = clickable_prefab.instantiate()
			container.add_child(clickable)
			unit_to_clickable[unit] = clickable
			
			clickable.setup_button( unit, selection_controller )
			
			# Connect to the mouse over slot event
			clickable.player_moused_over_slot.connect( on_player_moused_over_slot )

## The player has moused over one of the slots, so wake up the ability displayer.
func on_player_moused_over_slot(unit_to_display: Node3D) -> void:
	unit_ability_displayer.display( unit_to_display )
