extends CombatBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var push_up_force = 300.0
@export var push_back_force = 400.0
@export var Varible_Jump_Realise = 0.5
var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var animation_player = $AnimatedSprite2D as AnimatedSprite2D
@onready var timer_dash = $desh_timer as Timer
@onready var hpBar = $Camera2D/CanvasLayer/Hp_bar as Label
var _double_jump_change = false
var is_hit: bool = false
var is_fire: bool = false
var current_speed = 0
var is_dashing: bool = false
var timerIdle = 0.0
var slow_fall: bool = false
signal fire_active(active: bool)



func _ready() -> void:
	current_health = Starting_Health
	hpBar.text = str(current_health)
	# Подключаемся к сигналу урона
	damage_token.connect(_on_damage_taken)
	
func _on_damage_taken(amount: int, dir: Vector2) -> void:
	hpBar.text = str(current_health)
	is_hit = true
	var push_dir = Vector2.ZERO
	push_dir = (global_position - dir).normalized()
	push_dir.y = -1
	velocity = push_dir * Vector2(push_back_force, push_up_force)
	set_physics_process(false)
	await get_tree().create_timer(0.05).timeout
	if current_health == 0:
		animation_player.play("death_animation")
		return
	set_physics_process(true)
	animation_player.play("hit")

func _physics_process(delta: float) -> void:
	
	timerIdle += delta 
	if is_on_floor():
		slow_fall = false
	#fall
	if slow_fall:
		velocity.y = velocity.y + (gravity * 0.1) * delta
	else:
		velocity.y = velocity.y + gravity * delta
	
	
	if Input.is_action_just_pressed("up"):
		jump()
	if Input.is_action_just_released("up") and velocity.y < 0:
		timerIdle = 0
		velocity.y *= Varible_Jump_Realise
	
	if Input.is_action_just_pressed("fire") :
		timerIdle = 0
		on_fire()
	if Input.is_action_just_pressed("slow_fall") and not is_on_floor():
		velocity.y *= 0.5
		slow_fall = true
		_double_jump_change = false
		is_dashing
	
	if Input.is_action_just_released("slow_fall") :
		slow_fall = false
	
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		is_dashing = false
		timerIdle = 0
	
	var direction := Input.get_axis("left", "right")
	if is_dashing :
		timerIdle = 0
		velocity.x = lerp(velocity.x, direction * SPEED, 0.08)
	else:
		velocity.x = lerp(velocity.x, direction * SPEED, 0.1)
	
	if Input.is_action_just_pressed("dashL") and not is_dashing and not slow_fall:
		dash(1)

	if Input.is_action_just_pressed("dashR") and not is_dashing and not slow_fall:
		dash(-1)
		

		
	var animation = get_new_animation()
	animation_player.play(animation)
	move_and_slide()

func  dash(direction: int) -> void:
	is_dashing = true
	velocity.x = direction * 900
	timer_dash.start(0.5)

func get_new_animation() -> String:
	if is_hit:
		return "hit"
	if slow_fall:
		animation_player.flip_h = velocity.x < 0
		return "slow_fall"
	if is_fire:
		return "fire"
	var animation_new: String
	animation_player.flip_h = velocity.x < 0
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
		elif timerIdle > 0.5:
			animation_new = "idle"
	else:
		if velocity.y > 0.0:
			animation_new = "fall"
		elif _double_jump_change:
			animation_new = "jump"  # Обычный прыжок
		else:
			animation_new = "double_jump"  # Двойной прыжок
	return animation_new

func jump() -> void:
	if is_on_floor():
		_double_jump_change = true
		velocity.y = JUMP_VELOCITY
	elif _double_jump_change:
		_double_jump_change = false
		velocity.y = 0
		velocity.y += -400 
	else:
		return

func on_fire() -> void:
	is_fire = true
	fire_active.emit(is_fire)


func _on_timer_timeout() -> void:
	is_dashing = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_player.animation == "hit":
		is_hit = false
	if animation_player.animation == "fire":
		is_fire = false
	if animation_player.animation == "slow_fall":
		slow_fall = false
	if animation_player.animation == "death_animation":
		is_dead.emit(true)
