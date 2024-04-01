## Handles the visuals for a player's selection box.
class_name SelectionBox
extends Node2D

## How wide the selection border should be.
@export var selection_border_girth: float = 3.0
@export var selection_box_col: Color = Color.CORNFLOWER_BLUE

# Dragging data
var drag_start:  Vector2
var drag_end:    Vector2
var dragging: bool = false

## Update our drawing.
func selection_draw(start_pos: Vector2, is_dragging: bool) -> void:
	drag_start = start_pos
	dragging   = is_dragging
	queue_redraw()

# Handle drawing the visuals of our selection box.
func _draw() -> void:
	if dragging == true:
		draw_rect(
			Rect2(drag_start, get_viewport().get_mouse_position() - drag_start),
			selection_box_col, false, selection_border_girth
		)
