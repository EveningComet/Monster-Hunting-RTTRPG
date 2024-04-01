## When the player has at least one unit selected.
class_name Directing
extends PlayerInputControlState

func enter(msgs: Dictionary = {}) -> void:
	print("Directing :: Entered.")
	selection_controller.units_that_are_selected.connect( on_units_selected )
	
	## Subscribe to the event for abilities
	selection_controller.activating_unit_ability.connect(
		on_player_activated_ability_for_targeting
	)

func exit() -> void:
	selection_controller.units_that_are_selected.disconnect( on_units_selected )
	selection_controller.activating_unit_ability.disconnect(
		on_player_activated_ability_for_targeting
	)

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		my_state_machine.change_to_state("WaitingForUnitSelection")
		return
	
	# Tell our selected units to move
	if event.is_action_released("right_click"):
		
		# Get a ray of the mouse of the mouse position from the selection controller
		var mouse_position: Vector2 = selection_controller.get_viewport().get_mouse_position()
		var result = selection_controller.raycast_mouse( mouse_position )
		if result:
			
			# Set the destination, based on the position of the mouse
			# TODO: Loop through our units and find the slowest one. Set the speed
			# to temporarily be the slowest unit so everyone moves together.
			circle_formation_move( selection_controller.selected_units, result.position )

func on_units_selected(selected_units: Array[Node3D]) -> void:
	# There are no units selected, so dip.
	if selected_units.size() < 1:
		my_state_machine.change_to_state("WaitingForUnitSelection")

## The player is attempting to find a target for an ability.
func on_player_activated_ability_for_targeting(
	unit_activating: Node3D,
	ability_activated: AbilitySlotData
) -> void:
	my_state_machine.change_to_state(
		"FindingTargetForAbility",
		{unit_activating = unit_activating, ability_activated = ability_activated}
	)

func circle_formation_move(units_to_move: Array[Node3D], cursor_pos: Vector3) -> void:
	var unit_pos := cursor_pos
	
	# The distance that units should be away from each other.
	# TODO: Set this as a setting somewhere?
	var circle_formation_space_between_units: float = 3.0
	
	var circle_size = 0
	var unit_total_count_in_circle = 6 * circle_size
	var unit_count_in_circle: int = 0
	var current_angle = 0
	for x in units_to_move:
		
		# Move onto the next unit if this unit cannot move
		if x.has_node("Mover") == false:
			continue
		
		x.get_node("Mover").set_target_destination( unit_pos )	
		unit_count_in_circle += 1
		if unit_count_in_circle >= unit_total_count_in_circle:
			unit_count_in_circle = 0
			current_angle = 0
			circle_size += 1
			unit_total_count_in_circle = 6 * circle_size
			unit_pos.x = cursor_pos.x + circle_formation_space_between_units * circle_size
			unit_pos.y = cursor_pos.y
		else:
			current_angle += (PI/3) / circle_size
			unit_pos.x = cursor_pos.x + (circle_formation_space_between_units * circle_size) * cos(current_angle)
			unit_pos.z = cursor_pos.z + (circle_formation_space_between_units * circle_size) * sin(current_angle)
