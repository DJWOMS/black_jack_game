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
var current_card_broker_x := 50.0
var cards_broker := [] 


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
			_card.add_to_group("cards")
			call_deferred("add_child", _card)
	$Button.visible = false
	$Pass.visible = false


func btn():
	$Button.disabled = true
	$Pass.disabled = true


func check_count():
	var result = $WindowDialog.get_child(3)
	if Global.count > 21:
		btn()
		$WindowDialog.visible = true
		result.text = "You lose"


func check_count_pass():
	var result = $WindowDialog.get_child(3)
	check_count()
	if Global.count == 21:
		btn()
		$WindowDialog.visible = true
		result.text = "You win!!!"
	elif Global.brocker_count > 21:
		btn()
		$WindowDialog.visible = true
		result.text = "You win!!!"
	elif Global.brocker_count == Global.count:
		btn()
		$WindowDialog.visible = true
		result.text = "You win!!!"
	elif Global.brocker_count < Global.count:
		btn()
		$WindowDialog.visible = true
		result.text = "You win!!!"
	elif Global.brocker_count > Global.count:
		btn()
		$WindowDialog.visible = true
		result.text = "You lose"

func add_card_player_start():
	var last_child = get_node(".").get_child(get_child_count()-current_card)
	current_card += 1
	current_card_x += 100.0
	last_child.set_position(Vector2(current_card_x, current_card_y))
	last_child.facedown = false
	Global.count += last_child.value
	$PlayerCount.text = "Count: %s" % Global.count

func add_card_player():
	add_card_player_start()
	check_count()

func add_card_brocker():
	var last_child = get_node(".").get_child(get_child_count()-current_card)
	cards_broker.append(last_child)
	current_card += 1
	current_card_broker_x += 100.0
	last_child.set_position(Vector2(current_card_broker_x, 50.0))
	Global.brocker_count += last_child.value

	
func _on_Button_pressed():
	add_card_player()


func _on_NewGame_pressed():
	Global.reset()
	get_tree().change_scene("res://scene/Game.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Pass_pressed():
	cards_broker[0].facedown = false
	cards_broker[1].facedown = false
	while Global.brocker_count < 21:
		yield(get_tree().create_timer(1.0), "timeout")
		var last_child = get_node(".").get_child(get_child_count()-current_card)
		if last_child.value + Global.brocker_count <= 21:
			current_card += 1
			current_card_broker_x += 100.0
			last_child.set_position(Vector2(current_card_broker_x, 50))
			last_child.facedown = false
			Global.brocker_count += last_child.value
			$BrockerCount.text = "Count: %s" % Global.brocker_count
		else:
			break
	check_count_pass()


func _on_Start_pressed():
	add_card_player_start()
	add_card_player_start()
	add_card_brocker()
	add_card_brocker()
	$Button.visible = true
	$Pass.visible = true
	$Start.visible = false
