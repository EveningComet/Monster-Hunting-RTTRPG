## Can be activated by a character.
class_name Ability
extends Resource

## Name of the ability.
@export var ability_name: String = "New Ability"

## The description that will be displayed in the ui.
@export_multiline var ability_description: String = "An ability that is most bodacious."

## The icon of this ability.
@export var ability_icon: Texture2D

## How much time, in seconds, before you can activate this ability again?
@export var base_cooldown: float = 1.0

## Depending on the type of this ability, this is the furthest away the
## activator can "look" for a target.
@export var max_range: float = 10.0

## How much special points/mana/etc. does it cost to perform this ability?
@export var special_cost: int = 1

## How does this ability get its targets?
@export var targeting_logic: AbilityTargetingLogic

## An ability is defined by its effects.
@export var effects: Array[AbilityEffect]

## Activate this ability.
func execute(activator, target: Node3D, target_pos: Vector3):
	
	# Loop through our effects and execute them
	for ab in effects:
		ab.execute(activator, target, target_pos)
