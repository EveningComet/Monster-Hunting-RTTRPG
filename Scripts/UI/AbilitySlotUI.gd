## Handles displaying an ability for the player.
class_name AbilitySlotUI
extends TextureButton

## Gets fired when the player has pressed the slot. This will tell the
## ability displayer to tell something else to make the player enter the
## ability targeting state.
signal ability_slot_pressed(ability_slot_data: AbilitySlotData)

## The object that will display the ability's icon.
@export var ability_icon: TextureRect

## Displays the progress of the coolbar.
@export var progress_bar: TextureProgressBar

## Child responsible for displaying how much time is left in the cooldown.
@export var cooldown_counter_displayer: Label

## Displays how much time is left, in seconds.
@export var cooldown_timer: Timer

## The ability this slot is currently keeping track of.
var stored_ability: AbilitySlotData

func _physics_process(delta: float) -> void:
	cooldown_counter_displayer.set_text(
		"%3.1f" % cooldown_timer.time_left
	)
	progress_bar.value = (cooldown_timer.time_left / stored_ability.get_ability().base_cooldown) * 100

## Set the ability this ui should monitor.
func set_ability(new_ability: AbilitySlotData) -> void:
	stored_ability = new_ability
	ability_icon.set_texture( stored_ability.get_ability().ability_icon )

	# Hide the cooldown related info
	progress_bar.hide()
	cooldown_counter_displayer.hide()
	cooldown_timer.timeout.connect( on_timer_timeout )

	# Don't run physics unless the ability was executed or is cooling down
	set_physics_process( false )

	# See if the cooldown has to be updated
	if stored_ability.is_cooldown_finished() == false:
		progress_bar.show()
		cooldown_counter_displayer.show()
		cooldown_timer.set_wait_time( stored_ability.curr_cooldown )
		cooldown_timer.set_autostart( true )
		set_physics_process( true )

	# Subscribe to our button pressed event
	pressed.connect( on_button_pressed )

## The player has clicked on the ability. What should be done?
## Fire an event.
func on_button_pressed() -> void:
	# Do not allow the ability to be used if it is still cooling down
	if stored_ability.is_cooldown_finished() == false:
		return

	# Tell anyone interested that this ability has been pressed.
	ability_slot_pressed.emit( stored_ability )

## What to do when the player activates the ability this ui is monitoring?
func on_ability_executed() -> void:
	# Unhide the ui elements that will tell the player how long they have to
	# wait before they can execute the related ability
	progress_bar.show()
	cooldown_counter_displayer.show()
	cooldown_timer.start( stored_ability.get_ability().base_cooldown )

	# Time to run updates again
	set_physics_process( true )

## What to do when the timer is done?
func on_timer_timeout() -> void:
	cooldown_counter_displayer.hide()
	progress_bar.hide()

	# Don't run updates again.
	set_physics_process( false )
