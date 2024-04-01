## Responsible for holding a player's units.
class_name SelectionController
extends Node3D

## Emitted when the player has selected units.
signal units_that_are_selected( units_collected: Array[Node3D])

## Middleman event used to tell the player to enter ability target selection
## mode.
signal activating_unit_ability(unit_activating: Node3D, ability_activated: AbilitySlotData)

@export var selection_box: SelectionBox # The visuals of our selection
@export var cam:           Camera3D     # Our camera
@export var faction_owner: FactionOwner # Who do we belong to?
var ray_length: float = 1000            # How far to check with the mouse.

## The units we are keeping track of.
var selected_units: Array[Node3D] = []

var drag_start: Vector2 = Vector2.ZERO
var dragging:   bool    = false

## When the player is looking for a target for an ability and presses the left
## mouse button down, we don't want this to do anything.
var allowed_to_work: bool = true

# Using unhandled input to account for the mouse being over the ui
func _unhandled_input(event: InputEvent) -> void:
	if allowed_to_work == false:
		return
		
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# Start the selection
	if event.is_action_pressed("left_click") and dragging == false:
		drag_start = mouse_pos
		dragging   = true
		selection_box.selection_draw(drag_start, dragging)
	
	# We are still dragging
	if event is InputEventMouseMotion and dragging == true:
		selection_box.selection_draw(drag_start, dragging)
	
	if event.is_action_released("left_click") and dragging == true:
		dragging = false
		selection_box.selection_draw(drag_start, dragging)
		
		# Look for units to select
		select_units( mouse_pos )

## Set the status for allowed to work.
func set_allowed_to_work_status(new_status: bool) -> void:
	await get_tree().create_timer(0.1, false).timeout
	allowed_to_work = new_status

## Accessor for the selected units.
func get_selected_units() -> Array[Node3D]:
	return selected_units

## Call the selection through a button.
func select_unit_through_button(newly_selected_unit: Node3D) -> void:
	var allow_multi_select: bool = Input.is_action_pressed("allow_multi_select")
	if selected_units.size() > 0 and allow_multi_select == false:
		clear_selection()
		
	select_units_through_array( [newly_selected_unit] )
	
	# Tell anyone that cares about the selected units
	units_that_are_selected.emit( selected_units )

func select_units(m_pos: Vector2) -> void:
	# Attempt to get units in the box
	var newly_selected_units: Array[Node3D] = []
	if m_pos.distance_squared_to(drag_start) < 16:
		var u = get_unit_under_mouse( m_pos )
		if u != null:
			newly_selected_units.append( u )
	else:
		newly_selected_units.append_array( get_units_in_box(drag_start, m_pos) )
	
	# Loop through our old units and deselect them
	var allow_multi_select: bool = Input.is_action_pressed("allow_multi_select")
	if selected_units.size() > 0 and allow_multi_select == false:
		clear_selection()
	
	# Add the new units to our selection
	select_units_through_array( newly_selected_units )
	
	# Tell anyone that cares about the selected units
	units_that_are_selected.emit( selected_units )

## Attempt to select units through a passed array
func select_units_through_array(newly_selected_units: Array[Node3D] = []) -> void:
	for i in newly_selected_units:
		
		# Add the unit if we don't already have them selected
		if selected_units.has( i ) == false:
			
			# Subscribe to any relevant events
			# We want to know when this unit dies
			var cs: CharacterStats = i.get_node("CharacterStats")
			cs.unit_died.connect(on_unit_died)
			
			selected_units.append( i )

## Clear our selected units.
func clear_selection() -> void:
	# Unsub from any events on the unit.
	for u in selected_units:
		var cs: CharacterStats = u.get_node("CharacterStats")
		cs.unit_died.disconnect(on_unit_died)
	
	selected_units.clear()
	
	# Tell anyone that cares about the cleared selection
	units_that_are_selected.emit( selected_units )

## Return the potential unit under the mouse.
func get_unit_under_mouse(m_pos: Vector2):
	var result = raycast_mouse( m_pos )
	if result and result.collider.has_node("FactionOwner"):
		return result.collider

func get_units_in_box(top_left, bot_right) -> Array:
	# Redo our coords if they're not correct
	if top_left.x > bot_right.x:
		var tmp     = top_left.x
		top_left.x  = bot_right.x
		bot_right.x = tmp
	if top_left.y > bot_right.y:
		var tmp     = top_left.y
		top_left.y  = bot_right.y
		bot_right.y = tmp
	
	# Create the box
	var rect = Rect2(top_left, bot_right - top_left)
	var potential_units: Array = []
	
	# Check for units by looping through all the units
	# TODO: Is there a better way?
	for unit in get_tree().get_nodes_in_group("Units"):
		
		# If the unit is within our selection, add them
		if rect.has_point(cam.unproject_position(unit.global_transform.origin)):
			
			# If the unit has our faction, add them to our list
			if unit.get_node("FactionOwner").get_faction() == faction_owner.get_faction():
				potential_units.append( unit )
			
	return potential_units

## Raycast using the mouse position and return a query of the ray intersection.
func raycast_mouse(m_pos: Vector2):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end   = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		ray_start, ray_end
	)
	return space_state.intersect_ray( query )

## Raycast and check for areas. Mostly just to check for damageable components on an enemy.
func raycast_check_for_area(m_pos: Vector2):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end   = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		ray_start, ray_end
	)
	query.set_collide_with_bodies( false )
	query.set_collide_with_areas( true )
	query.set_collision_mask( 0b0100 )
	return space_state.intersect_ray( query )

## When a selected unit dies, what should we do?
func on_unit_died(dying_unit: CharacterStats) -> void:
	# Remove the dead unit from our selection and unsub from the event.
	selected_units.erase( dying_unit.get_parent() )
	dying_unit.unit_died.disconnect(on_unit_died)
	
	# Tell anything about the change.
	units_that_are_selected.emit( selected_units )

## Used as a middleman between the ui to make the 
func ability_slot_button_activated(
	unit_activating_ability: Node3D,
	ability_activated: AbilitySlotData
) -> void:
	activating_unit_ability.emit( unit_activating_ability, ability_activated )
