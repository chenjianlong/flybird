extends RigidBody2D

var speed: int = 100
var gravityScale: float = 1.5

var hp: int = 3
var point: int = 0

var screen_size

signal hpChangedEvent(oldHp: int, hp: int)
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated.animation = Main.currentAnimation
	screen_size = get_viewport_rect().size
	
	set_linear_velocity(Vector2(speed, 0))
	set_linear_damp(0)
	set_gravity_scale(gravityScale)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
	connect("body_entered", Callable(self, "on_body_entered_event"))
	
func _process(_delta: float):
	if rotation < deg_to_rad(-30):
		rotation = deg_to_rad(-30)
		set_angular_velocity(0)
	if get_linear_velocity().y > 0:
		set_angular_velocity(3)
		
	if Input.is_action_just_pressed("fly_button"):
		set_linear_velocity(Vector2(speed, -200))
		set_angular_velocity(-3)
		set_gravity_scale(0)
		animated.play()
		$wing.play()
		
	if (animated.frame == 2):
		animated.stop()
		animated.frame = 0
		set_gravity_scale(gravityScale)
		
	position.y = clamp(position.y, 0, screen_size.y)

func on_body_entered_event(_other_body):
	$hit.play()
	var oldHp = hp
	hp = hp - 1
	emit_signal("hpChangedEvent", oldHp, hp)
