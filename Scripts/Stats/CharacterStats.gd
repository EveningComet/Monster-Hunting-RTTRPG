## Base class for a character's stats.
class_name CharacterStats
extends Node

## Called when a unit is dead.
signal unit_died(stats: CharacterStats)

## Called when a unit has been revived.
signal unit_revived(stats: CharacterStats)

## Fired when this character gains experience points.
signal experience_gained(growth_data: Array)

## Event for when a stat has been changed.
signal stat_changed(stats: CharacterStats)

@export_category("Starting Attributes")
@export var starting_fitness:   int = 10
@export var starting_dexterity: int = 10
@export var starting_will:      int = 10

@export_category("Other Stats")
@export var base_attack: int = 1

## For enemies, this is how much experience that should be dealt on death.
@export var experience_on_death: int = 100

## Easy access for our stats
var stats:     Dictionary = {}

## The current level this character is at.
var current_level: int = 1

## This character's current experience points.
var curr_xp: int = 0

## How much experience is required to level up?
var experience_required: int = get_experience_required(current_level)

## The experience the character has acquired over its lifetime.
var total_experience_points: int = 0

## When a character levels up, this is the percentage increase for calculations.
# TODO: Move this to the job/characterclass?
var experience_growth_percentage: float = 1.10

func _ready():
	initialize_stats()

## Setup the base stats for this character.
func initialize_stats() -> void:
	# Attributes
	stats[StatTypes.stat_types.Fitness]        = Stat.new(
		starting_fitness,
		true
	)
	stats[StatTypes.stat_types.Dexterity]      = Stat.new(
		starting_dexterity,
		true
	)
	stats[StatTypes.stat_types.Will]           = Stat.new(
		starting_will,
		true
	)
	
	# Vitals
	stats[StatTypes.stat_types.MaxHP]          = Stat.new(
		stats[StatTypes.stat_types.Fitness].get_calculated_value() * 2,
		true
	)
	stats[StatTypes.stat_types.CurrentHP]      = SimpleStat.new(
		get_stat(StatTypes.stat_types.MaxHP).get_calculated_value(),
		true
	)
	stats[StatTypes.stat_types.MaxSP] = Stat.new(
		stats[StatTypes.stat_types.Will].get_calculated_value() * 2,
		true
	)
	stats[StatTypes.stat_types.CurrentSP] = SimpleStat.new(
		stats[StatTypes.stat_types.MaxSP].get_calculated_value(),
		true
	)

# TODO: Recharge health and special points overtime.

## Get the physical power.
func get_physical_power() -> int:
	# TODO: Replace the 5 here.
	return round(
		 (stats[StatTypes.stat_types.Dexterity].get_calculated_value() + 5) / 2
	)

func take_damage(amount: int) -> void:
	var base_value = stats[StatTypes.stat_types.CurrentHP].get_base_value()
	# TODO: Defense.
	base_value    -= amount
	base_value     = max(0, base_value)
	stats[StatTypes.stat_types.CurrentHP].set_base_value( base_value )
	
	# Tell anything that cares our stat has changed.
	stat_changed.emit(self)
	
	if base_value <= 0:
		die()
	
func heal(amount: int) -> void:
	var base_value = stats[StatTypes.stat_types.CurrentHP].get_base_value()
	var max_hp     = stats[StatTypes.stat_types.MaxHP].get_calculated_value()
	base_value    += amount
	base_value     = min(max_hp, base_value)
	stats[StatTypes.stat_types.CurrentHP].set_base_value( base_value )
	
	# Tell anything that cares our stat has changed.
	stat_changed.emit(self)

## Easy wrapper for subtracting from our special stat.
func sub_special_stat(amount: int) -> void:
	var base_value = stats[StatTypes.stat_types.CurrentSP].get_base_value()
	base_value -= amount
	base_value = max(0, base_value)
	stats[StatTypes.stat_types.CurrentSP].set_base_value( base_value )
	
	# Tell anything that cares about the stat change
	stat_changed.emit(self)

## Recharge the special points.
func recharge_special_stat(amount: int) -> void:
	var base_value = stats[StatTypes.stat_types.CurrentSP].get_base_value()
	var maxsp = stats[StatTypes.stat_types.MaxSP].get_calculated_value()
	base_value += amount
	base_value = min(maxsp, base_value)
	stats[StatTypes.stat_types.CurrentSP].set_base_value( base_value )
	
	# Tell anything that cares about the stat change
	stat_changed.emit(self)

# Get a specific stat
func get_stat(stat_to_get: StatTypes.stat_types) -> Stat:
	return stats[stat_to_get]
	
## Add a modifier for the passed stat.
func add_modifier(stat_type: StatTypes.stat_types, modifier: StatModifier) -> void:
	stats[stat_type].add_modifier( modifier )
	# Tell anything that cares about our stat change
	stat_changed.emit( self )

## Remove a modifier from the passed stat.
func remove_modifier(stat_type: StatTypes.stat_types, modifier: StatModifier) -> void:
	stats[stat_type].remove_modifier( modifier )
	# Tell anything that cares about our stat change
	stat_changed.emit( self )

func raise_base_value(stat_type: StatTypes.stat_types, amount: float) -> void:
	stats[stat_type]

## Set a specific stat.
func set_stat(stat_type: StatTypes.stat_types, stat_value: float) -> void:
	stats[stat_type].set_base_value( stat_value )
	
	# Tell anything that cares about the stat change
	stat_changed.emit(self)

#### Experience Methods

## Get the experience required to level up.
## Calculation is: 100 * (growth_percent^( current level - 1))
func get_experience_required(level: int) -> int:
	return round( 100 * pow(experience_growth_percentage, level - 1) )

## Give this character experience points.
func gain_experience(gain_amount: int) -> void:
	total_experience_points += gain_amount
	curr_xp += gain_amount
	var growth_data: Array = []
	
	# While the experience is high enough, keep leveling up.
	while curr_xp >= experience_required:
		curr_xp -= experience_required
		growth_data.append( [experience_required, experience_required] )
		level_up()
	growth_data.append( [curr_xp, experience_required] )
	
	# Notify anything about the change in experience
	experience_gained.emit( growth_data )

## Function called when a character level ups.
func level_up() -> void:
	pass

####

func die() -> void:
	# Tell everyone that cares we're dead.
	EventBus.hp_depleted.emit( self )
