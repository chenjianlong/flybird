extends Node2D

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animatedSprite2D.animation_finished.connect(onAnimationFinished)
	animatedSprite2D.play()


func onAnimationFinished():
	animatedSprite2D.stop()
	queue_free()
