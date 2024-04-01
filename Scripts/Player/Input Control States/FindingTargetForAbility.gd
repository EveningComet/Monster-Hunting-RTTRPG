## The player enters this state when they select an ability on a character to
## execute.
class_name FindingTargetForAbility
extends PlayerInputControlState

## The unit we are currently monitoring.
var unit_finding_ability_for: Node3D

## The stats of the unit we are currently monitoring.
var current_unit_stats: CharacterStats

## Using an ability slot data object, keep track of the current ability the
## player is looking for a target for.
var curr_ability_slot_data: AbilitySlotData

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{"unit_activating": var unit_activating, "ability_activated": var ability_activated}:
			unit_finding_ability_for = unit_activating
			current_unit_stats       = unit_finding_ability_for.get_node("CharacterStats")
			current_unit_stats.unit_died.connect( on_unit_died )
			curr_ability_slot_data   = ability_activated
	
	# If this state was somehow entered without either of these present, bail
	if unit_finding_ability_for == null or curr_ability_slot_data == null:
		printerr(
			"FindingTargetForAbility :: Serious error! This state was entered
			without an ability. Bailing."
		)
		my_state_machine.change_to_state("WaitingForUnitSelection")
	
	print("FindingTargetForAbility :: Entered.")
	
	# Turn off the selection controller
	selection_controller.set_allowed_to_work_status( false )

func exit() -> void:
	# Don't keep track of the ability anymore
	if current_unit_stats != null:
		current_unit_stats.unit_died.disconnect( on_unit_died )
	
	curr_ability_slot_data   = null
	current_unit_stats       = null
	unit_finding_ability_for = null
	
	# Re-enable the selection controller
	selection_controller.set_allowed_to_work_status( true )

func check_for_unhandled_input(event: InputEvent) -> void:
	
	# Backout to a relevant state based on how many units the player has selected
	if event.is_action_pressed("back"):
		find_what_state_to_return_to()
		return
	
	var result = selection_controller.raycast_mouse( get_viewport().get_mouse_position() )
	
	# See what kind of target this ability is looking for
	# TODO: Testing an ability. Delete when no longer needed.
	if event.is_action_pressed("left_click") and result:
		var ability_handler: AbilityHandler = unit_finding_ability_for.get_node("AbilityHandler")
		ability_handler.execute_ability(
			curr_ability_slot_data,
			null,
			result.position
		)
		
		# Finished the ability, return to one of the regular states
		find_what_state_to_return_to()

func find_what_state_to_return_to() -> void:
	if selection_controller.selected_units.size() > 0:
		my_state_machine.change_to_state("Directing")
	else:
		my_state_machine.change_to_state("WaitingForUnitSelection")

func on_unit_died(stats: CharacterStats) -> void:
	# Find the right state to return to
	current_unit_stats.unit_died.disconnect( on_unit_died )
	current_unit_stats = null
	find_what_state_to_return_to()
