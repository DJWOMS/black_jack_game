extends Node2D
class_name Card

var rank: String
var suit: String
var value: int
var facedown = true


func get_value() -> int:
	return value

func get_rank() -> String:
	return suit+rank

func _ready():
	$Texture.texture_normal = load('res://sprite/%s%s.png' % [suit, rank])
	$Texture.disabled = false


func _on_Texture_pressed():
	if $Texture.disabled:
		$Texture.disabled = false
	else:
		$Texture.disabled = true
