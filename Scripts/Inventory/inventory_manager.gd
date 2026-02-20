class_name InventoryManager extends Node

@export var inventory_container: VBoxContainer

var items: Array[Item]

func add_item_to_inventory(item_packed_scene: PackedScene) -> bool:
	var item: Item = item_packed_scene.instantiate()
	
	for i in items:
		if i.item_name == item.item_name:
			push_warning("Item already exists in inventory!")
			item.queue_free()
			return false
	
	inventory_container.add_child(item)
	items.append(item)
	return true

func remove_item_from_inventory(item_name: Items.ItemName) -> bool:
	for i in len(items):
		if items[i].item_name == item_name:
			items[i].play_exit_animation()
			items.remove_at(i)
			return true
			
	return false
