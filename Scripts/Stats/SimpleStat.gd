###
# For stats, such as current hp, that don't need modifiers.
###
class_name SimpleStat
extends Stat

func _init(init_value: float, is_int: bool):
	super(init_value, is_int)
