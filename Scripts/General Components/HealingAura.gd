## When allied characters are within the confines, they will be healed.
class_name HealingAura
extends Area3D

## The faction component so that this object can heal the right characters.
@export var my_faction: FactionOwner

## The max time that this is allowed to exist.
@export var max_lifetime: float = 10.0
var curr_lifetime:        float = 0.0

## How long before this object checks for things to activate.
# TODO: What if this should be infinite?
@export var activation_rate: float = 1.0
var curr_tick_time:    float = 0.0

## How much should this heal?
@export var healing_power: int = 5

var allies: Array[CharacterStats] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	my_faction = get_node("FactionOwner")
	body_entered.connect( on_body_entered )

func _physics_process(delta: float) -> void:
	curr_lifetime  += delta
	curr_tick_time += delta
	
	if curr_tick_time > activation_rate:
		perform_heal()
		curr_tick_time = 0.0
	
	if curr_lifetime > max_lifetime:
		queue_free()

## Used by external factors to set the healing power.
func set_healing_power(new_power: int) -> void:
	healing_power = new_power

func perform_heal() -> void:
	for ally in allies:
		# TODO: Check to make sure the ally is not knocked out/dead.
		ally.heal( healing_power )

## When an ally enters, keep track of them for healing.
func on_body_entered(body: Node3D) -> void:
	# Ignore anything that does not have a faction
	if body.has_node("FactionOwner") == false:
		return
		
	# Do not heal enemies or things that cannot be healed
	var entrant: FactionOwner = body.get_node("FactionOwner")
	if entrant.get_faction() != my_faction.get_faction() or body.has_node("CharacterStats") == false:
		return
	
	# Add the friendly to list of allies
	var stats: CharacterStats = body.get_node("CharacterStats")
	allies.append( stats )

## When an ally exits this area, do not healt heal them anymore.
func on_body_exited(body: Node3D) -> void:
	# Ignore anything that does not have a faction
	if body.has_node("FactionOwner") == false:
		return
		
	# Not friendly, so ignore
	var entrant: FactionOwner = body.get_node("FactionOwner")
	if entrant.get_faction() != my_faction.get_faction() or body.has_node("CharacterStats") == false:
		return
	
	# Remove the ally
	var stats: CharacterStats = body.get_node("CharacterStats")
	allies.erase( stats )
