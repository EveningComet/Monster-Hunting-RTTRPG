## A class that a player's unit can be. It dictates what weapons can be used,
## the abilities that can be activated, etc.
class_name Job extends Resource

@export_category("Base Information")
@export var job_name: String = "New Job"
@export_multiline var description: String = "A pretty cool class."

## The abilities that are available to this class.
@export var abilities: Array[Ability] = []

@export_category("Starting Stats")
@export var starting_fitness:   int = 20
@export var starting_dexterity: int = 20
@export var starting_will:      int = 20

@export_category("Increase Data")
# When the character levels up/puts points into this class,
# this is how their stats should rise.
@export var fitness_gain_on_increase:   int = 3
@export var dexterity_gain_on_increase: int = 3
@export var will_gain_on_increase:      int = 3
