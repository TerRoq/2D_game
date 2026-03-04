class_name CombatBody2D
extends CharacterBody2D

@export var Overide_Damage_Receiving: bool = false
@export var Damage_Receiver: DamageReceiver2D
@export var Starting_Health: int = 100
@export var Max_Health: int = 100

var alive: bool = true
var current_health: int
signal is_dead(death: bool)
signal damage_token(amount: int, dir: Vector2)

func _ready() -> void:
	Damage_Receiver.damage_received.connect(register_damage)

##handles the taking of damage, use take_damage() instead
func register_damage(damage: int,  dir: Vector2 , ignore_overide: bool = false) -> void:
	if ignore_overide:
		current_health = clampi(current_health - damage, 0, Max_Health)
		damage_token.emit(damage, dir)
	else:
		if !Overide_Damage_Receiving and current_health > 0:
			current_health = clampi(current_health - damage, 0, Max_Health)
			damage_token.emit(damage, dir)
	if current_health == 0:
		alive = false
		


func take_damage(damage: int, dir: Vector2) -> void:
	print(current_health)
	register_damage(damage, dir, true)

func heal_damage(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, Max_Health)
