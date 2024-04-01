## Base class for a state that controls what the player can do at a given time.
class_name PlayerInputControlState
extends State

## The player's selection controller. Many states will need to know about the
## selected units.
var selection_controller: SelectionController

func setup_state(new_sm) -> void:
	super(new_sm)
	selection_controller = my_state_machine.selection_controller
