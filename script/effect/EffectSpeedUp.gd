extends Node2D

signal speedUpSignal(node: Node2D, other)


func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "onSpeedUpEntered"))
	$VisibleOnScreenNotifier2D.screen_exited.connect(onScreenExited)


func onSpeedUpEntered(otherBody):
	emit_signal("speedUpSignal", self, otherBody)


func onScreenExited():
	queue_free()
