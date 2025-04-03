extends Node

@onready var dieAudio: AudioStreamPlayer = $DieAudio
@onready var swooshAudio: AudioStreamPlayer = $SwooshAudio
@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

# 场景常量数据
enum SCENE {Home, Game, Over}
const sceneMap: Dictionary = {
	SCENE.Home: preload("res://scene/Home.tscn"),
	SCENE.Game: preload("res://scene/Game.tscn"),
	SCENE.Over: preload("res://scene/Over.tscn")
}

var point: int = 0

func _ready():
	swooshAudio.play()
	transitionAnimation.play("fade-in")
	await transitionAnimation.animation_finished

func changeScene(scene: SCENE):
	var scenePath = sceneMap[scene]
	swooshAudio.play()
	transitionAnimation.play_backwards("fade-in")
	await transitionAnimation.animation_finished
	get_tree().change_scene_to_packed(scenePath)
	transitionAnimation.play("fade-in")
