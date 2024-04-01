## Inherited version of the stats component for enemies.
class_name EnemyStats
extends CharacterStats

func die() -> void:
	unit_died.emit( self )
	# TODO: Die and then fade on death at some point. For now, just remove us immediately.
	get_parent().queue_free()
