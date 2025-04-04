extends Node2D


func _ready() -> void:
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	Main.randomBackground()
	$Background/ParallaxBackground/ParallaxLayer/Background.texture = Main.currentBackground
	$UI/Bird.animation = Main.currentAnimation
	
func startGame():
	Main.changeScene(Main.SCENE.Game)
