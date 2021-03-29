extends Node2D

onready var Global = get_node("/root/Global")


func _process(delta):
	if $LineEdit.text.empty():
		$Button.disabled = true
	else:
		$Button.disabled = false

func _on_Button_pressed():
	Global.player_name = get_node("LineEdit").text
	get_tree().change_scene("res://scene/Game.tscn")
