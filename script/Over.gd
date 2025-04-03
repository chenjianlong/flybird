extends Node2D

func _ready() -> void:
	$Control/Score.text = String.num_int64(Main.point)
	$Control/Menu.connect("pressed", Callable(self, "home"))

func home():
	Main.changeScene(Main.SCENE.Home)
