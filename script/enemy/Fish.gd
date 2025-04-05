extends AnimatableBody2D

var speed: int = 150


func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(onScreenExited)


func _physics_process(delta: float) -> void:
	position.x = position.x - speed * delta


func onScreenExited():
	queue_free()
