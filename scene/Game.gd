extends Node2D
class_name Game

onready var Global = get_node("/root/Global")
var card = preload('res://scene/Card.tscn')
#var card: Card

var rank := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "J", "Q", "K"]
var suit := ["cardClubs", "cardDiamonds", "cardHearts", "cardSpades"]
var cards := []


func _ready():
	$PlayerName.text = "Player: " + Global.player_name
	var x := 1.0
	var y := 1.0
	randomize()
	rank.shuffle()
	suit.shuffle()
	for s in suit:
		for r in rank:
			var _card = card.instance()
			_card.suit = s
			_card.rank = r
			if r in "23456789":
				_card.value = int(r)
			elif r == "A":
				_card.value = 1
			#elif r == "T":
				#_card.value = 11
			elif r in "JQK":
				_card.value = 10
			_card.position.x = x
			_card.position.y = y
			y += 2.0
			call_deferred("add_child", _card)
	



func _on_Button_pressed():
	var last_child = get_tree().get_child(get_child_count()-1)
	print(last_child.value)
