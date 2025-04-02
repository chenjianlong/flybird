extends Node2D


func _ready() -> void:
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	
func startGame():
	Main.changeScene("res://scene/Game.tscn")
