extends Control

onready var option_button = $CenterContainer/VBoxContainer/OptionButton

func _ready():
	add_items()

func add_items():
	option_button.add_item("Multiplayer")
	option_button.add_item("Contro il computer")
	
func _on_Start_pressed():
	if option_button.get_selected_id() == 0:
		GameManager.modality = GameManager.Enemies.MULTIPLAYER
	elif option_button.get_selected_id() == 1:
		GameManager.modality = GameManager.Enemies.COMPUTER
	get_tree().change_scene("res://scenes/tic_tac_toe.tscn")

func _on_Quit_pressed():
	get_tree().quit()
