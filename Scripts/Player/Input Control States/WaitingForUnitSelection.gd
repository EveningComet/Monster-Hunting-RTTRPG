## The state for when the player does not currently have any units selected.
class_name WaitingForUnitSelection
extends PlayerInputControlState

func enter(msgs: Dictionary = {}) -> void:
	print("WaitingForUnitSelection :: Entered.")
	
	# Subscribe to the selection controller event. This state
	# needs to be exited as soon as the player has a unit selected.
	selection_controller.units_that_are_selected.connect( on_units_selected )
	
	## Subscribe to the event for abilities
	selection_controller.activating_unit_ability.connect(
		on_player_activated_ability_for_targeting
	)
	
	# There should be no units selected upon entering this state
	selection_controller.clear_selection()

# TODO: Testing selecting a damageable component.
func check_for_unhandled_input(event: InputEvent) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var result = selection_controller.raycast_check_for_area( mouse_position )
	if result and event.is_action_pressed("right_click"):
		printerr("WaitingForUnitSelection :: %s" % result)

func exit() -> void:
	# This state should not pay attention to unit selection updates when it is
	# not active
	selection_controller.units_that_are_selected.disconnect( on_units_selected )
	selection_controller.activating_unit_ability.disconnect(
		on_player_activated_ability_for_targeting
	)

func on_units_selected(selected_units: Array[Node3D]) -> void:
	# The player has units selected. Move onto the next state.
	if selected_units.size() > 0:
		my_state_machine.change_to_state("Directing")

## The player is attempting to find a target for an ability.
func on_player_activated_ability_for_targeting(
	unit_activating: Node3D,
	ability_activated: AbilitySlotData
) -> void:
	my_state_machine.change_to_state(
		"FindingTargetForAbility",
		{unit_activating = unit_activating, ability_activated = ability_activated}
	)
