## Responsible for displaying a unit's abilities to the player.
class_name UnitAbilityDisplayer
extends Control

## A reference to the ability slot ui scene.
@export var a_slot_scene: PackedScene

## The ui object that will house all the spawned ability slots.
@export var container: Container

## The selection controller is the middleman for activating abilities.
## This monitored selection controller will then the player's input state
## machine to start targeting an ability.
var selection_controller: SelectionController

## The object of the unit we are currently keeping track of.
var current_unit: Node3D

## Should we hide?
var begin_hiding:  bool = false

## Time before turning off.
var hide_time:     float = 2.0

func _ready() -> void:
	hide_display()

## Set the selection controller to monitor so that the player can find
## targets for the ability they want to activate.
func set_selection_controller(new_sc: SelectionController) -> void:
	selection_controller = new_sc
	selection_controller.units_that_are_selected.connect( on_units_selected )

## Display the abilities of the passed unit object.
func display(unit_to_display: Node3D) -> void:
	
	# Quickly clean out all the old data
	hide_display()
	
	# The passed unit does not have any abilities to display. So quit.
	if unit_to_display.has_node("AbilityHandler") == false:
		hide_display()
		return
	
	# Get the stored abilities on the unit
	var ability_handler: AbilityHandler = unit_to_display.get_node("AbilityHandler")
	var instanced_abilities: Array[AbilitySlotData] = ability_handler.get_abilities()
	
	# Don't show if the unit has no abilities
	if instanced_abilities.size() < 1:
		hide_display()
		return
	
	# Set the current unit and display all the abilities
	current_unit = unit_to_display
	ability_handler.ability_executed.connect( on_ability_executed )
	for ab in instanced_abilities:
		var a_slot: AbilitySlotUI = a_slot_scene.instantiate()
		a_slot.set_ability( ab )
		container.add_child( a_slot )
		
		# Connect to the event for when the player clicks on the ability slot
		a_slot.ability_slot_pressed.connect( on_ability_button_pressed )
	
	# Everything's good, so display away
	visible = true

## Hide the bar.
func hide_display() -> void:
	visible = false
	begin_hiding = false
	
	if current_unit != null:
		
		# Unsub from all the relevant events
		current_unit.get_node("AbilityHandler").ability_executed.disconnect( on_ability_executed )
	
	current_unit = null
	
	# Destroy all the abilities that were displayed.
	clear_display()

## Used to clear any displayed ability slots.
func clear_display() -> void:
	for node in container.get_children():
		container.remove_child( node )
		node.queue_free()

## When the player has units selected, what should the ability displayer do?
func on_units_selected(selected_units: Array[Node3D]) -> void:
	# If there is exactly one unit to display, display their abilities
	if selected_units.size() == 1:
		display( selected_units[0] )
	elif selected_units.size() == 0:
		hide_display()

## When the player has pressed a slot containing an ability, tell the player's
## input control state to change to the ability targeting state.
func on_ability_button_pressed(ability: AbilitySlotData) -> void:
	selection_controller.ability_slot_button_activated(
		current_unit,
		ability
	)

## When an ability gets executed for the character, what should be done?
func on_ability_executed(index: int) -> void:
	var a_slot_ui: AbilitySlotUI = container.get_child( index )
	if a_slot_ui != null:
		a_slot_ui.on_ability_executed()

## When the unit being monitored is dead, do not keep track of them anymore.
func on_unit_died(dying_unit: CharacterStats):
	hide_display()
