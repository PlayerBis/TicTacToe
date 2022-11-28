extends Node2D

onready var tileMap = $TileMap
onready var tileMapHover = $TileMapHover
enum Turn {PLAYER_1 = 1, PLAYER_2 = 0}
var turn = Turn.PLAYER_1
var mouse_pos
var game_over
var move_wait = false
var rng = RandomNumberGenerator.new()
onready var rngRand = rng.randomize()

func _ready():
	game_over = false
	$UI/player_1.text = config.nome
	$UI/score.text = str(config.punteggio_player1) + "-" + str(config.punteggio_player2)
	# UI
	if config.modality == config.Enemies.MULTIPLAYER:
		$UI/player_1.text = config.nome
		$UI/player_2.text = config.nome_avversario
		$UI/player_2.add_color_override("font_color", Color(0, 0, 0, 0.5))
		
	else:
		$UI/player_1.text = config.nome
		$UI/player_2.text = config.nome_avversario
		$UI/player_2.add_color_override("font_color", Color(0, 0, 0, 0.5))

func _input(event):
	mouse_pos = tileMap.world_to_map(get_global_mouse_position())
	
	# Hover
	if event is InputEventMouseMotion:
		if (game_over == false and
			mouse_pos.x <= 2 and 
			mouse_pos.y <= 2 and
			mouse_pos.x >= 0 and
			mouse_pos.y >= 0):
			if tileMap.get_cell(mouse_pos.x, mouse_pos.y) == -1:
				tileMapHover.clear()
				if config.modality == config.Enemies.COMPUTER:
					if turn == Turn.PLAYER_1:
						tileMapHover.set_cell(mouse_pos.x, mouse_pos.y, Turn.PLAYER_1)
				else:
					tileMapHover.set_cell(mouse_pos.x, mouse_pos.y, turn)
	
	# Inserimento scelta
	if event is InputEventMouseButton:
		if (game_over == false and
			mouse_pos.x <= 2 and 
			mouse_pos.y <= 2 and
			mouse_pos.x >= 0 and
			mouse_pos.y >= 0 ):
			if event.button_index == BUTTON_LEFT and event.is_pressed():
				if tileMap.get_cell(mouse_pos.x, mouse_pos.y) == -1:
					if move_wait == false:
						MusicController.play_selezione_music()
						tileMap.set_cell(mouse_pos.x, mouse_pos.y, turn)
						_check_board()
						if game_over == false:
							switch_turn()
					if config.modality == config.Enemies.COMPUTER:
						if tileMap.get_used_cells().size() != 9:
							move_wait = true
							$Timer.start()
func ai_computer():
	var num_posizioni_libere = 0
	var posizioni_libere = []
	var posizione_libera = []
	var random_num

	
	for righe in range(3):
		for colonne in range(3):
			if tileMap.get_cell(righe, colonne) == -1:
				posizione_libera = [righe, colonne]
				posizioni_libere.append(posizione_libera)
				num_posizioni_libere += 1
	random_num = rng.randi_range(0, num_posizioni_libere - 1)
	
	tileMap.set_cell(posizioni_libere[random_num][0], posizioni_libere[random_num][1], turn)
	_check_board()
	if game_over == false:
		switch_turn()
		
func switch_turn():
	if turn == Turn.PLAYER_1:
		turn = Turn.PLAYER_2
		$UI/player_1.add_color_override("font_color", Color(0, 0, 0, 0.5))
		$UI/player_2.add_color_override("font_color", Color(0, 0, 0, 1))
	else:
		turn = Turn.PLAYER_1
		$UI/player_1.add_color_override("font_color", Color(0, 0, 0, 1))
		$UI/player_2.add_color_override("font_color", Color(0, 0, 0, 0.5))
		
# Condizioni di vittoria
func _check_board():
	# orizzontale
	for i in range(3):
		if (
			tileMap.get_cell(0, i) != -1 and
			tileMap.get_cell(0, i) == tileMap.get_cell(1, i) and
			tileMap.get_cell(0, i) == tileMap.get_cell(2, i)
		):
			_winner(tileMap.get_cell(0, i))
			return
	# verticale
	for i in range(3):
		if (
			tileMap.get_cell(i, 0) != -1 and
			tileMap.get_cell(i, 0) == tileMap.get_cell(i, 1) and
			tileMap.get_cell(i, 0) == tileMap.get_cell(i, 2)
		):
			_winner(tileMap.get_cell(i, 0))
			return
	# diagonale 2
	for _i in range(3):
		if (
			tileMap.get_cell(0, 0) != -1 and
			tileMap.get_cell(0, 0) == tileMap.get_cell(1, 1) and
			tileMap.get_cell(0, 0) == tileMap.get_cell(2, 2)
		):
			_winner(tileMap.get_cell(0, 0))
			return
			
	# diagonale 2 
	for _i in range(3):
		if (
			tileMap.get_cell(2, 0) != -1 and
			tileMap.get_cell(2, 0) == tileMap.get_cell(1, 1) and
			tileMap.get_cell(2, 0) == tileMap.get_cell(0, 2)
		):
			_winner(tileMap.get_cell(2, 0))
			return
	# Tie
	if tileMap.get_used_cells().size() == 9:
		_winner(-1)
# vittoria

func _winner(winner):
	var risultato =  $UI/game_over/CenterContainer/VBoxContainer/risultato
	var game_over_score = $UI/game_over/CenterContainer/VBoxContainer/game_over_score
	
	game_over = true
	match winner:
		-1:
			risultato.text = "Pareggio"
			MusicController.play_pareggio_music()
		0:
			config.punteggio_player2 += 1
			if config.modality == config.Enemies.MULTIPLAYER:
				risultato.text = config.nome_avversario +"\nha vinto"
				MusicController.play_vittoria_music()
			else:
				risultato.text = "Hai perso"
				MusicController.play_sconfitta_music()
		1:
			config.punteggio_player1 += 1
			if config.modality == config.Enemies.MULTIPLAYER:
				risultato.text = config.nome +"\nha vinto"
			else:
				risultato.text = "Hai vinto"
			MusicController.play_vittoria_music()
	$UI/score.text = str(config.punteggio_player1) + "-" + str(config.punteggio_player2)
	game_over_score.text = str(config.punteggio_player1) + "-" + str(config.punteggio_player2)
	$UI/game_over.visible = true

func _on_torna_al_menu_pressed():
	MusicController.play_selezione_music()
	config.punteggio_player2 = 0
	config.punteggio_player1 = 0
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_inizia_una_nuova_partita_pressed():
		MusicController.play_selezione_music()
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	if game_over == false:
		ai_computer()
		move_wait = false
