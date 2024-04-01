## Controls what should be done based on the what the player is currently doing.
## E.g: if the player does not have any units selected, then the system is
## waiting for the player to select a unit.
class_name PlayerController
extends StateMachine

## Our selection controller.
@export var selection_controller: SelectionController

func set_me_up() -> void:
	super()
	
func _unhandled_input(event: InputEvent) -> void:
	curr_state.check_for_unhandled_input( event )
