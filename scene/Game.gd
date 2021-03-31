extends Node2D
class_name Game

onready var Global = get_node("/root/Global")
var card = preload('res://scene/Card.tscn')

var rank := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "J", "Q", "K"]
var suit := ["cardClubs", "cardDiamonds", "cardHearts", "cardSpades"]
var cards := []
var current_card := 1
var current_card_x := 50.0
var current_card_y := 300.0
var current_card_broker_x := 50.0
var cards_broker := [] 


func _ready():
	$PlayerName.text = "Player " # + Global.player_name
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

	var btn = $WindowDialog.get_close_button()
	btn.visible = false

func btn():
	$Button.disabled = true
	$Pass.disabled = true


func print_result() -> String:
	var result_text = "\n%s: %s\nBrocker: %s" % [
		Global.player_name, Global.count, Global.brocker_count
	]
	return result_text

func check_count() -> void:
	if Global.count > 21:
		lose()


func win() -> void:
	var result = $WindowDialog.get_child(2)
	btn()
	$WindowDialog.visible = true
	result.text = "You win !!!" + print_result()
	$SoundWin.play()


func lose() -> void:
	var result = $WindowDialog.get_child(2)
	btn()
	$WindowDialog.visible = true
	result.text = "You lose" + print_result()
	$SoundLose.play()


func draw() -> void:
	var result = $WindowDialog.get_child(2)
	btn()
	$WindowDialog.visible = true
	result.text = "The game ended in a draw"  + print_result()
	$SoundDraw.play()


func check_count_pass() -> void:
	check_count()
	if Global.count == 21:
		win()
	elif Global.brocker_count > 21:
		win()
	elif Global.brocker_count == Global.count:
		draw()
	elif Global.brocker_count < Global.count:
		win()
	elif Global.brocker_count > Global.count:
		lose()


func add_card_player_start() -> void:
	var last_child = get_node(".").get_child(get_child_count()-current_card)
	current_card += 1
	current_card_x += 100.0
	last_child.set_position(Vector2(current_card_x, current_card_y))
	last_child.facedown = false
	$SoundCard.play()
	Global.count += last_child.value
	$PlayerCount.text = "Count: %s" % Global.count

func add_card_player() -> void:
	add_card_player_start()
	check_count()

func add_card_brocker(_facedown=false) -> void:
	var last_child = get_node(".").get_child(get_child_count()-current_card)
	cards_broker.append(last_child)
	current_card += 1
	current_card_broker_x += 100.0
	last_child.set_position(Vector2(current_card_broker_x, 50.0))
	last_child.facedown = false
	$SoundCard.play()
	Global.brocker_count += last_child.value
	if _facedown == true:
		$BrockerCount.text = "Count: %s" % Global.brocker_count
	

	
func _on_Button_pressed() -> void:
	add_card_player()


func _on_NewGame_pressed() -> void:
	Global.reset()
	get_tree().change_scene("res://scene/Game.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Pass_pressed() -> void:
	cards_broker[0].facedown = false
	cards_broker[1].facedown = false
	while Global.brocker_count < 21:
		yield(get_tree().create_timer(1.0), "timeout")
		var last_child = get_node(".").get_child(get_child_count()-current_card)
		if last_child.value + Global.brocker_count <= 21:
			add_card_brocker(true)
		else:
			break
	check_count_pass()


func _on_Start_pressed() -> void:
	add_card_player_start()
	add_card_player_start()
	add_card_brocker()
	add_card_brocker()
	$Button.visible = true
	$Pass.visible = true
	$Start.visible = false
