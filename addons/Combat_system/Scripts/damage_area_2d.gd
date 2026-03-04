class_name DamageArea2D
extends Area2D

@export var Damage: int = 10

signal damage_dealt(amount: int)

func _ready() -> void:
	self.area_entered.connect(deal_damage)

func deal_damage() -> void:
	damage_dealt.emit(Damage)
