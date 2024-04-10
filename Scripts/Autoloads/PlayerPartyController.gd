extends Node

var party: Array[PlayerCharacterStats] = []

func add_party_member(party_member_to_add: PlayerCharacterStats) -> void:
	party.append( party_member_to_add )

func remove_party_member(party_member_to_remove: PlayerCharacterStats) -> void:
	party.erase( party_member_to_remove )
