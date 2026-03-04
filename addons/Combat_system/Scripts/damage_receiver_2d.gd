class_name DamageReceiver2D
extends Area2D

signal damage_received(Damage: int, dir: Vector2)

func _ready() -> void:
	self.area_entered.connect(take_damage)


func take_damage(area: Area2D) -> void:
	if area is DamageArea2D:
		var damage_area_zone: DamageArea2D = area
		emit_signal("damage_received",damage_area_zone.Damage, damage_area_zone.global_position)
