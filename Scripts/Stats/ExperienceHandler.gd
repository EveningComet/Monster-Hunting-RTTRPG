## Responsible for giving experience points to the player's characters when
## enemies die.
class_name ExperienceHandler extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.hp_depleted.connect( on_hp_depleted )

## Distributes the passed points to the monitored player's units.
func give_experience(experience_amount: int) -> void:
	for participant: PlayerCharacterStats in PlayerPartyController.party:
		participant.gain_experience( experience_amount )

## When an enemy dies, give the experience to the player's party.
func on_hp_depleted(character: CharacterStats) -> void:
	if character is EnemyStats:
		var experience_amount: int = character.experience_on_death
		give_experience( experience_amount )
