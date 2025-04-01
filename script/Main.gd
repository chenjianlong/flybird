extends Node2D

@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

func _ready():
	home()
	
func home():
	var homeResource = preload("res://scene/Home.tscn")
	var homeInst = homeResource.instantiate()
	add_child(homeInst)
	$Home/Control/Start.connect("pressed", Callable(self, "startGame"))
	$swoosh.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	if (get_node_or_null("Over") != null):
		$Over.queue_free()
		
func startGame():
	var gameResource = preload("res://scene/Game.tscn")
	var game = gameResource.instantiate()
	add_child(game)
	
	game.end_game.connect(endGame)
	
	$Home.queue_free()
	$swoosh.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
	
func endGame(point: int):
	var overResource = preload("res://scene/Over.tscn")
	var over = overResource.instantiate()
	add_child(over)
	$Over/Control/Score.text = String.num_int64(point)
	$Over/Control/Menu.connect("pressed", Callable(self, "home"))
	$Game.queue_free()
	$die.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished
