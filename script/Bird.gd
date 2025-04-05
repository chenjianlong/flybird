extends RigidBody2D

const INIT_SPEED = 100
const SPEED_UP = 100
const INIT_FLY_UP_SPEED = -200
const SPEED_UP_FLY_UP_SPEED = -300
const INIT_CAMERA_OFFSET = 200
const SPEED_UP_CAMERA_OFFSET = 450
const CAMERA_MOVE_SPEED = 40

@export var speed: int = INIT_SPEED
@export var flyUpSpeed: int = INIT_FLY_UP_SPEED
@export var cameraOffset: float = INIT_CAMERA_OFFSET
@export var hp: int = 3
@export var gravityScale: float = 1.5

var point: int = 0

var screen_size

var isSpeedUp = false

signal hpChangedEvent(oldHp: int, hp: int)

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var speedTimer: Timer = $Timer

func _ready():
	animated.animation = Main.currentAnimation
	screen_size = get_viewport_rect().size
	
	set_linear_velocity(Vector2(speed, 0))
	set_linear_damp(0)
	set_gravity_scale(gravityScale)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
	connect("body_entered", Callable(self, "on_body_entered_event"))
	speedTimer.timeout.connect(onSpeedUpTimeout)


func _process(delta: float):
	if rotation < deg_to_rad(-30):
		rotation = deg_to_rad(-30)
		set_angular_velocity(0)
	if get_linear_velocity().y > 0:
		if rotation > deg_to_rad(75):
			set_angular_velocity(6)
		else:
			set_angular_velocity(3)
		
	if Input.is_action_just_pressed("fly_button"):
		set_linear_velocity(Vector2(speed, flyUpSpeed))
		set_angular_velocity(-3)
		set_gravity_scale(0)
		animated.play()
		$wing.play()
		
	if (animated.frame == 2):
		animated.stop()
		animated.frame = 0
		set_gravity_scale(gravityScale)
		
	position.y = clamp(position.y, 0, screen_size.y)

	if (isSpeedUp):
		cameraOffset = clamp(cameraOffset + CAMERA_MOVE_SPEED * delta, INIT_CAMERA_OFFSET, SPEED_UP_CAMERA_OFFSET)
	else:
		cameraOffset = clamp(cameraOffset - CAMERA_MOVE_SPEED * delta, INIT_CAMERA_OFFSET, SPEED_UP_CAMERA_OFFSET)


func on_body_entered_event(_other_body):
	if (speed != INIT_SPEED):
		return

	$hit.play()
	var oldHp = hp
	hp = max(hp - 1, 0)
	emit_signal("hpChangedEvent", oldHp, hp)


func speedUp():
	speedTimer.start()
	speedTimer.one_shot = true
	$speedup.play()
	$SpeedUp.visible = true
	speed = speed + SPEED_UP
	flyUpSpeed = SPEED_UP_FLY_UP_SPEED
	isSpeedUp = true


func onSpeedUpTimeout():
	speed = INIT_SPEED
	$speedup.stop()
	$speedup_end.play()
	$SpeedUp.visible = false
	flyUpSpeed = INIT_FLY_UP_SPEED
	isSpeedUp = false
