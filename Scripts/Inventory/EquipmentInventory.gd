## Stores the equipment for a character.
class_name EquipmentInventory extends Inventory

const MAX_NUMBER_EQUP_SLOTS: int = 4

## Reference to the stats component.
var stats: CharacterStats

func set_stats(new_stats: CharacterStats) -> void:
	stats = new_stats
	initialize_slots()

func initialize_slots() -> void:
	max_size = MAX_NUMBER_EQUP_SLOTS
	super()

## A modified version of the drop slot data method that only accepts equipment
func drop_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	
	if grabbed_slot_data.stored_item == null:
		return grabbed_slot_data
		
	# If something wants to place an item in us that is not a weapon, stop it
	if grabbed_slot_data.stored_item.item_type != ItemTypes.ItemTypes.Equipment:
		return grabbed_slot_data
		
	# Prevent armors and weapons from going into the wrong slot
	# 0: Weapons
	# 1-3: Armor/Accessories
	if index < 1 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Weapon:
		return grabbed_slot_data
	elif index > 0 and grabbed_slot_data.stored_item.equip_type != ItemTypes.EquipmentTypes.Accessory:
		return grabbed_slot_data
	
	if OS.is_debug_build() == true:
		print("EquipInentory :: Found a usable equipment piece.")
	
	# This is where the equipment will be equipped and then notify the 
	# stats and all that
	
	return super.drop_slot_data( grabbed_slot_data, index )

## A modified version of the drop single slot data method that only accepts equipment
func drop_single_slot_data(grabbed_slot_data: ItemSlotData, index: int) -> ItemSlotData:
	
	if grabbed_slot_data.stored_item == null:
		return grabbed_slot_data
	
	# If something wants to place an item in us that is not a weapon, stop it
	if grabbed_slot_data.stored_item.item_type != ItemTypes.ItemTypes.Equipment:
		return grabbed_slot_data
	
	# This is where the equipment will be equipped and then notify the 
	# stats and all that
	
	return super.drop_single_slot_data( grabbed_slot_data, index )
