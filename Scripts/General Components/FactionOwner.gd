## A general component for easily telling whomst something belongs to.
class_name FactionOwner
extends Node

## Whomst does this unit belong to?
@export var faction_owner: int = 0

## Return the id of the faction owner.
func get_faction() -> int:
	return faction_owner

## Set which  faction the attached object belongs to.
func set_faction(new_faction: int) -> void:
	faction_owner = new_faction
