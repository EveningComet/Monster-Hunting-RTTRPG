## Stores data for an item.
class_name ItemData extends Resource

@export_category("Base Item Info")
@export var           localization_name:        String = "New Item"
@export_multiline var localization_description: String = "An item."
@export var item_type: ItemTypes.ItemTypes = ItemTypes.ItemTypes.Consumable
@export var item_icon: Texture
@export var max_stack_size: int = 1

@export_category("Equipment Info")
@export var equip_type: ItemTypes.EquipmentTypes = ItemTypes.EquipmentTypes.None

@export_category("Weapon Info")
@export var weapon_type: ItemTypes.WeaponTypes = ItemTypes.WeaponTypes.None
