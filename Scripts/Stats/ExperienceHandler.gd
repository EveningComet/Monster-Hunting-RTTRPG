## Responsible for giving experience points to the player's characters when
## enemies die.
class_name ExperienceHandler
extends Node

## The player that is being monitored so that their characters can gain experience
## points.
@export var player: Node3D

## Stores the player's characters that will be given experience.
@export var party_members: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	search_for_party( player.get_node("FactionOwner") )
	search_for_enemies()

## A quick and dirty way to get all of the units belonging to a player.
func search_for_party(player_faction: FactionOwner) -> void:
	for unit in get_tree().get_nodes_in_group("Units"):
		var unit_faction: FactionOwner = unit.get_node("FactionOwner")
		if unit_faction.get_faction() == player_faction.get_faction():
			party_members.append( unit )
			
	print_rich("[color=yellow]ExperienceHandler :: Characters monitoring: %s.[/color]" % [party_members])

func search_for_enemies() -> void:
	var player_faction: FactionOwner = player.get_node("FactionOwner")
	for enemy in get_tree().get_nodes_in_group("Units"):
		var enemy_faction: FactionOwner = enemy.get_node("FactionOwner")
		if enemy_faction.get_faction() != player_faction.get_faction():
			var enemy_stats: EnemyStats = enemy.get_node("CharacterStats")
			enemy_stats.unit_died.connect( on_death )

## Based on the dying character, give experience to all of the player's
## controlled characters.
func on_death(dying_enemy: EnemyStats) -> void:
	print_rich("[color=yellow][b]ExperienceHandler :: Enemy(%s) has died. Giving experience.[/b][/color]" % dying_enemy.get_parent().name)
	for c in party_members:
		# TODO: Make an experience data class component for cleanliness?
		var stats: CharacterStats = c.get_node("CharacterStats")
		var experience_amount: int = dying_enemy.experience_on_death
		stats.gain_experience( experience_amount )

## Distributes the passed points to the monitored player's units.
func give_experience(experience_amount: int) -> void:
	for participant in party_members:
		var stats: CharacterStats = participant.get_node("CharacterStatss")
		stats.gain_experience( experience_amount )

func give_experience_to_party(experience_amount: int, party: Array[Node3D]) -> void:
	pass
