extends Control

onready var option_button = $CenterContainer/VBoxContainer/OptionButton

func _process(delta):
	# modalità
	if option_button.get_selected_id() == 0:
		config.modality = config.Enemies.MULTIPLAYER
	elif option_button.get_selected_id() == 1:
		config.modality = config.Enemies.COMPUTER
		
	# placeholder
	if config.modality == config.Enemies.COMPUTER:
		$CenterContainer/VBoxContainer/avversario.placeholder_text = "Computer"
	else: 
		$CenterContainer/VBoxContainer/avversario.placeholder_text = "Player 2"

func _ready():
	add_items()

func add_items():
	option_button.add_item("Multiplayer")
	option_button.add_item("Contro il computer")
	
func _on_Start_pressed():
	# player 1
	if $CenterContainer/VBoxContainer/nome.text == "":
		config.nome = "Player 1"
	else:
		config.nome = $CenterContainer/VBoxContainer/nome.text
	# opponent
	if $CenterContainer/VBoxContainer/avversario.text == "":
		if config.modality == config.Enemies.COMPUTER:
			config.nome_avversario = "Computer"
		else:
			config.nome_avversario = "Player 2"
	else:
		config.nome_avversario = $CenterContainer/VBoxContainer/avversario.text
	MusicController.play_start_music()
	$start_timer.start(1)

func _on_Quit_pressed():
	MusicController.play_quit_music()
	$quit_timer.start(1)

func _on_quit_timer_timeout():
	get_tree().quit()

func _on_start_timer_timeout():
	get_tree().change_scene("res://scenes/tic_tac_toe.tscn")
