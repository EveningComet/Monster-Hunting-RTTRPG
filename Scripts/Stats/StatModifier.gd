## Stores data for something that modifies a stat.
class_name StatModifier

## Which type of modifier does this give?
var stat_modifier_type: StatModifierTypes.stat_modifier_types

## The modifier's value
var value: float = 0.0

## How much priority does this modifier have?
var sort_order: int = 0

func _init(
	v: float,
	mod_type: StatModifierTypes.stat_modifier_types,
	sort_priority: int
):
	stat_modifier_type = mod_type
	value              = v
	sort_order         = sort_priority

## Get the value of this modifier
func get_value() -> float:
	return value

## What type of modifier is this?
func get_modifier_type():
	return stat_modifier_type

## Get the sorting order.
func get_sort_order() -> int:
	return sort_order
