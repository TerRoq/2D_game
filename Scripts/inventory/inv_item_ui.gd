extends Control

class_name invItem_ui

@export var invSlot: InvItem
@onready var picture = $picture as TextureRect
@onready var num = $number as Label



func _ready() -> void:
	picture.texture = invSlot.texture
	num.text = invSlot.count
