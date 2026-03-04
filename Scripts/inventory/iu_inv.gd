extends GridContainer

@export var inventory: Inv
@export var slot_number: int
@onready var greedInv = $InvGreed

var sence_to_add = preload("res://Scripts/inventory/invItem_ui.tscn")

func _ready() -> void:
	var _new_scene_node = sence_to_add.instantiate()
	
	
	inventory = Inv.new()
	for i in range(slot_number + 1):
		inventory.items.append(InvItem.new())
		greedInv.add_child(invItem_ui.new())
		
