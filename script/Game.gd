extends Node2D

@onready var camera2d: Camera2D = $Camera2D
@onready var bird: RigidBody2D = $Bird

@onready var background: Node2D = $BackGround
@onready var pipes: Node2D = $Pipes

var pipeInterval: int = 150
var pipeCount: int = 3
var isOver: bool = false

func _ready() -> void:
	for i in range(30):
		createPipe()
		
func _process(_delta: float) -> void:
	camera2d.position.x = bird.position.x - 90
	var count = int(bird.position.x / 1152)
	background.position.x = count * 1152
	if (!isOver && bird.hp <= 0):
		endGame()

func endGame():
	isOver = true
	Main.point = bird.point
	Main.changeScene(Main.SCENE.Over)

func createPipe():
	var createPositionX = pipeCount * pipeInterval
	var createPositionY = randf_range(80, 320)
	
	var pipeResource = preload("res://scene/Pipe.tscn")
	var newPipe = pipeResource.instantiate()
	newPipe.position.x = createPositionX
	newPipe.position.y = createPositionY
	newPipe.name = String.num_int64(pipeCount)
	pipes.add_child(newPipe)
	
	newPipe.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(onPipeScreenExited.bind(newPipe))
	newPipe.get_node("Coin").connect("body_entered", Callable(self, "onBirdEntered"))
	
	pipeCount += 1

func onPipeScreenExited(exitedPipe: Node2D):
	exitedPipe.queue_free()
	createPipe()
	
func onBirdEntered(other_body):
	if (other_body == bird):
		$Bird/point.play()
		bird.point += 1
