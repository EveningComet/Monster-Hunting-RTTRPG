## Manages the camera for the player.
class_name CameraController
extends SpringArm3D

@export_category("Panning")
## How fast the camera moves.
@export var pan_speed: float = 25.0

## How close the mouse must be to the border of the screen to move the camera.
@export var border_margin: int = 20

@export_category("Zooming")
@export var max_zoom: float   = 30.0
@export var min_zoom: float   = 3.0
@export var zoom_speed: float = 50.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_zoom( delta )
	update_panning( delta )
	
func update_zoom(delta: float) -> void:
	if Input.is_action_just_released("zoom_in"):
		global_translate(global_transform.basis.z * -zoom_speed * delta)
	if Input.is_action_just_released("zoom_out"):
		global_translate(global_transform.basis.z * zoom_speed * delta)
	
	# Clamp how far away and close we can go.
	global_position.y = clamp(global_position.y, min_zoom, max_zoom)
	
## Update the panning.
func update_panning(delta: float) -> void:
	# Reset the vector we're using to move
	var move_v: Vector3 = Vector3.ZERO
	
	# Movement based on non-mouse input
	move_v.x = Input.get_action_strength("pan_right") - Input.get_action_strength("pan_left")
	move_v.z = Input.get_action_strength("pan_down") - Input.get_action_strength("pan_up")

	# Movement based on the mouse's position on the screen
	var viewport_size: Vector2 = get_viewport().size
	var mouse_pos:     Vector2 = get_viewport().get_mouse_position()
	if mouse_pos.x < border_margin:
		move_v.x -= 1
	if mouse_pos.y < border_margin:
		move_v.z -= 1
	if mouse_pos.x > viewport_size.x - border_margin:
		move_v.x += 1
	if mouse_pos.y > viewport_size.y - border_margin:
		move_v.z += 1
	
	# Normalize the vector and move the camera
	var scaled_speed: float = pan_speed * global_position.y * 0.1
	move_v = move_v.rotated(Vector3.UP, rotation_degrees.y)
	global_translate(move_v.normalized() * delta * scaled_speed)

## Reset the camera's rotation when the player asks for it.
func reset_camera_rotation() -> void:
	pass
