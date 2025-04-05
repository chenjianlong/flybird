extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")

@onready var camera2d: Camera2D = $Camera2D
@onready var bird: RigidBody2D = $Bird

@onready var background: Node2D = $Background
@onready var pipes: Node2D = $Pipes
@onready var hpAnimatedSprite2D: AnimatedSprite2D = $UI/HP/AnimatedSprite2D
@onready var birdSpeedUpEffect: GPUParticles2D = $BirdSpeedUpEffect

var pipeInterval: int = 150
var pipeCount: int = 3
var isOver: bool = false

const enemies: Array[PackedScene] = [
	preload("res://scene/enemy/Cloud.tscn"),
	preload("res://scene/enemy/Fish.tscn"),
	preload("res://scene/enemy/Shark.tscn")
]

const pipeUpBrown = preload("res://image/pipe2_up.png")
const pipeDownBrown = preload("res://image/pipe2_down.png")

func _ready() -> void:
	$Background/ParallaxBackground/ParallaxLayer/Background.texture = Main.currentBackground
	bird.hpChangedEvent.connect(onHpChangedEvent)
	$Enemies/Timer.timeout.connect(onEnemiesTimeout)
	$Hp/Timer.timeout.connect(onHpTimeout)
	$SpeedUp/Timer.timeout.connect(onSpeedUpTimeout)
	changeHp(bird.hp)
	for i in range(30):
		createPipe()


func changeHp(hp: int):
	$UI/HP/HP.text = String.num_int64(hp)
	hpAnimatedSprite2D.play()


func _process(_delta: float) -> void:
	camera2d.position.x = bird.position.x - bird.cameraOffset
	birdSpeedUpEffect.position = bird.position
	birdSpeedUpEffect.emitting = bird.isSpeedUp
	var count = int(bird.position.x / 1152)
	background.position.x = count * 1152
	if (!isOver && bird.hp <= 0):
		endGame()

	if (hpAnimatedSprite2D.frame == 3):
		hpAnimatedSprite2D.frame = 0
		hpAnimatedSprite2D.stop()


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
	if (int(pipeCount / 10.0) % 2 == 1):
		newPipe.get_node("Up/Sprite2D").texture = pipeUpBrown
		newPipe.get_node("Down/Sprite2D").texture = pipeDownBrown
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


func onHpChangedEvent(oldHp: int, hp: int):
	if (oldHp > hp):
		var effectHit = preload("res://scene/effect/EffectHit.tscn").instantiate()
		effectHit.position = bird.position
		add_child(effectHit)
		changeHp(bird.hp)


func onEnemiesTimeout():
	var enemy = RandomUtils.randomEle(enemies).instantiate()
	var createPositionY = randf_range(50, 450)
	enemy.position.x = bird.position.x + 1000
	enemy.position.y = createPositionY
	add_child(enemy)


func onHpTimeout():
	var hp = preload("res://scene/effect/EffectHp.tscn").instantiate()
	var createPositionY = randf_range(100, 300)
	hp.position.x = bird.position.x + 1500
	hp.position.y = createPositionY
	add_child(hp)
	hp.addHpSignal.connect(onHpEntered)


func onSpeedUpTimeout():
	var speedUp = preload("res://scene/effect/EffectSpeedUp.tscn").instantiate()
	var createPositionY = randf_range(100, 300)
	speedUp.position.x = bird.position.x + 1500
	speedUp.position.y = createPositionY
	add_child(speedUp)
	speedUp.speedUpSignal.connect(onSpeedUpEntered)


func onHpEntered(node: Node2D, otherBody):
	if (otherBody == bird):
		$Bird/hp.play()
		bird.hp += 1
		changeHp(bird.hp)
		node.queue_free()


func onSpeedUpEntered(node: Node2D, otherBody):
	if (otherBody == bird):
		bird.speedUp()
		node.queue_free()
