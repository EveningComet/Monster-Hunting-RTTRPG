## A button that works as an alternative way for the player to select their units.
class_name ClickableUnitButton
extends BaseButton

signal player_moused_over_slot( monitored_unit: Node3D )

# TODO: Tooltip of unit on hover.

## Quick and easy way to make the selection controller select a unit.
var selection_controller: SelectionController

## The unit this is monitoring.
var stored_unit: Node3D

func setup_button(new_unit: Node3D, new_sc: SelectionController) -> void:
	# TODO: For safety, unsub from any events if a unit previously existed here.
	stored_unit          = new_unit
	selection_controller = new_sc
	
	# Connect to the unit death event to turn this button off
	var cs: CharacterStats = stored_unit.get_node("CharacterStats")
	cs.unit_died.connect(on_unit_died)
	
	# Connect to our button event
	pressed.connect(on_button_pressed)
	
	# Connect to the mouse over event
	mouse_entered.connect( on_mouse_entered )

## When the unit we care about dies, what should we do?
func on_unit_died(stats: CharacterStats) -> void:
	# Set to no longer be clickable.
	disabled = true

func on_button_pressed() -> void:
	# Tell the player's selection controller to select the unit
	selection_controller.select_unit_through_button( stored_unit )
	## TODO: Double click focus

func on_mouse_entered() -> void:
	# Fire an event to display the unit we want to display
	if disabled != true:
		player_moused_over_slot.emit( stored_unit )
	print("PlayerClickableUnit :: %s has seen the player's mouse." % name)
