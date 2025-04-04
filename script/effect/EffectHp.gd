extends Node2D

signal addHpSignal(node: Node2D, other)

func _ready() -> void:
	$Area2D.connect("body_entered", Callable(self, "onHpEntered"))
	$VisibleOnScreenNotifier2D.screen_exited.connect(onScreenExited.bind(self))


func onHpEntered(other_body):
	emit_signal("addHpSignal", self, other_body)


func onScreenExited(n: Node2D):
	n.queue_free()
