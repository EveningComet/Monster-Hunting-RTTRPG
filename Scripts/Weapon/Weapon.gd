## An object that a player character can attack with.
class_name Weapon
extends Node3D

@export_category("Weapon Data")
@export var base_damage: int = 5

## How often this weapon can attack.
@export var action_rate: float = 1.0

@export_category("Ranged Info")
## Where should the projectiles fire out of this weapon?
@export var fire_position: Node3D
@export var spread: float = 3.0

## How many projectiles should be spawned at once?
@export var num_shots_at_once: int = 1

## If this weapon shoots real projectiles, what does it spawn?
@export var fires_real_projectile: bool = false
@export var projectile_to_fire: PackedScene 

@export_category("Melee")
@export var is_melee: bool = false

## If this weapon is a melee one, then it should be guaranteed to have a hitbox
## component attached.
# TODO: Could this just be a regular area3d node?
@export var melee_hitbox: MeleeHitbox

var attack_modifier: StatModifier

func _ready() -> void:
	pass

func attacked() -> void:
	pass
