extends Node2D
class_name Game

onready var Global = get_node("/root/Global")
var card = preload('res://scene/Card.tscn')
#var card: Card

var rank := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "J", "Q", "K"]
var suit := ["cardClubs", "cardDiamonds", "cardHearts", "cardSpades"]
var cards := []
var current_card := 1
var current_card_x := 50.0
var current_card_y := 300.0


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
			elif r in "JQK":
				_card.value = 10
			_card.position.x = x
			_card.position.y = y
			y += 2.0
			call_deferred("add_child", _card)


func check_count():
	if Global.count > 21:
		$Result.text = "Game over"

func _on_Button_pressed():
	var last_child = get_node(".").get_child(get_child_count()-current_card)
	current_card += 1
	current_card_x += 100.0
	last_child.set_position(Vector2(current_card_x, current_card_y))
	last_child.facedown = false
	Global.count += last_child.value
	check_count()
