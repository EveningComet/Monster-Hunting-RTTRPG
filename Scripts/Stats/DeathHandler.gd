## Handles removing enemies from the scene.
class_name DeathHandler extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.hp_depleted.connect( on_hp_depleted )

func on_hp_depleted(character: CharacterStats) -> void:
	if character is EnemyStats:
		character.get_parent().queue_free()
