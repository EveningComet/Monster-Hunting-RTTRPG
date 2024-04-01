## Area component that assists with getting neaby valid targets for a unit.
class_name AwarenessRadius
extends Area3D

func _ready() -> void:
	body_entered.connect( on_body_entered )
	body_exited.connect( on_body_exited )

func on_body_entered(body: Node3D) -> void:
	# Ignore ourself
	if body == get_parent():
		return

func on_body_exited(body: Node3D) -> void:
	# Ignore ourself
	if body == get_parent():
		return
