## A class responsible for passing around needed data to multiple objects that want to know
## the same thing. It also makes it easier to pass along informatoin that would
## be very tedious otherwise.
extends Node

signal hp_depleted(character: CharacterStats)
