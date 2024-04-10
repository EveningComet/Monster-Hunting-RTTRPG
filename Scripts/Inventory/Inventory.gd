## Houses items.
class_name Inventory extends Node

## Whenever this inventory gets updated, pass it along.
signal inventory_updated(inventory: Inventory)

## When interacted with, we want others to know about the interaction.
signal inventory_interacted(inventory_data: Inventory, index: int, button: int)

## The max amount of items that can be held.
@export var max_size: int = 50

## The items currently being kept track of.
@export var stored_items: Array[ItemSlotData] = []

var money: int = 0

func initialize_slots() -> void:
	stored_items.clear()
	for i in max_size:
		var slot_data: ItemSlotData = ItemSlotData.new()
		slot_data.stored_item = null
		slot_data.quantity    = 0
		stored_items.insert(i, slot_data)

## Return a slot data object, given the passed index.
func grab_slot_data(index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	# If we have a slot to move, remove the slot and tell anyone caring about the change.
	if slot_data != null and slot_data.stored_item != null:
		stored_items[index] = null
		inventory_updated.emit( self )
		return slot_data
	else:
		return null

## Attempt to drop a single slot.
func drop_single_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	if slot_data == null or slot_data.stored_item == null:
		stored_items[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data) == true:
		slot_data.fully_merge_with( grabbed_slot_data.create_single_slot_data() )
	
	
	inventory_updated.emit( self )
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null 

## Attempt to drop a slot data into at the index, and swap the item if we can
func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	var slot_data: ItemSlotData = stored_items[index]
	
	var return_slot_data: ItemSlotData
	if slot_data != null and slot_data.stored_item != null and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		stored_items[index] = grabbed_slot_data
		return_slot_data    = slot_data
	
	inventory_updated.emit( self )
	return return_slot_data

## Use the stored item at the passed index.
func use_slot_data(index: int) -> void:
	# TODO: Make this return the item so that the characters will be able to use them.
	var slot_data: ItemSlotData = stored_items[index]
	
	# There is no item at the passed index, so do nothing
	if slot_data.stored_item == null:
		return
	
	# Depending on the item, this is where we do stuff.
	# If the item is a consumable, it needs to do its thing and then decrement.
	if slot_data.stored_item.item_type == ItemTypes.ItemTypes.Consumable:
		slot_data.quantity -= 1
		
		# TODO: This is where the usage of the item will go.
		
		if slot_data.quantity < 1:
			stored_items[index] = null
	
	# Tell anything that needs to know about the change
	inventory_updated.emit( self )
	
	if OS.is_debug_build() == true:
		print("Inventory :: Attempting to use item: %s." % [slot_data.stored_item.localization_name])

## Used when adding a singular slot data.
func add_singular_slot_data(slot_data: ItemSlotData) -> bool:
	
	# If we find a slot we can stack to, try it
	for index in stored_items.size():
		if stored_items[index] != null and stored_items[index].can_fully_merge_with(slot_data) == true:
			stored_items[index].fully_merge_with(slot_data)
			inventory_updated.emit( self )
			return true
	
	# If we find a null location, add the item
	for index in stored_items.size():
		if stored_items[index] == null:
			stored_items[index] = slot_data
			inventory_updated.emit( self )
			return true
	
	# Add an item to a slot if it has nothing
	for index in stored_items.size():
		if stored_items[index] != null and stored_items[index].stored_item == null:
			stored_items[index] = slot_data
			inventory_updated.emit( self )
			return true
	
	if OS.is_debug_build() == true:
		printerr("Inventory :: Could not add the slot data (%s) (%s)." % [slot_data, slot_data.stored_item.localization_name])
	
	return false

## When the player clicks on an item slot in the ui, we want to keep track of that.
func on_slot_clicked(index: int, button: int) -> void:
	inventory_interacted.emit( self, index, button )
