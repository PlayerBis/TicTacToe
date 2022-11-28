extends Node2D

onready var tileMap = $TileMap
onready var tileMapHover = $TileMapHover
onready var timer_computer_move = $timer_computer_move
enum Turn {PLAYER_1 = 1, PLAYER_2 = 0}
var turn = Turn.PLAYER_1
var mouse_pos
var game_over
var move_wait = false
var rng = RandomNumberGenerator.new()
onready var rngRand = rng.randomize()

func _ready():
	game_over = false
	# UI
	if GameManager.modality == GameManager.Enemies.MULTIPLAYER:
		$UI/player_1_hover.visible = true
		$UI/player_1.visible = true
		$UI/player_2_hover.visible = true
	else:
		$UI/player_1_hover.visible = true
		$UI/player_1.visible = true
		$UI/pc_hover.visible = true

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
				if GameManager.modality == GameManager.Enemies.COMPUTER:
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
						tileMap.set_cell(mouse_pos.x, mouse_pos.y, turn)
						switch_turn()
					_check_board()
					if GameManager.modality == GameManager.Enemies.COMPUTER:
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
	switch_turn()
	_check_board()
		
func switch_turn():
	if turn == Turn.PLAYER_1:
		turn = Turn.PLAYER_2
		if GameManager.modality == GameManager.Enemies.COMPUTER:
			$UI/player_1.visible = false
			$UI/pc.visible = true
		else:
			$UI/player_1.visible = false
			$UI/player_2.visible = true
	else:
		turn = Turn.PLAYER_1
		if GameManager.modality == GameManager.Enemies.COMPUTER:
			$UI/player_1.visible = true
			$UI/pc.visible = false
		else:
			$UI/player_1.visible = true
			$UI/player_2.visible = false
		
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

func disable_ui():
	$UI/vs.visible = false
	$UI/player_1.visible = false
	$UI/player_1_hover.visible = false
	$UI/player_2.visible = false
	$UI/player_2_hover.visible = false
	$UI/pc.visible = false
	$UI/pc_hover.visible = false
	
# vittoria
func _winner(winner):
	game_over = true
	
	if GameManager.modality == GameManager.Enemies.COMPUTER:
		winner+=10
	match winner:
		-1:
			disable_ui()
			$UI/hai_pareggiato.visible = true
		0:
			disable_ui()
			$UI/player_2_ha_vinto.visible = true
		1:
			disable_ui()
			$UI/player_1_ha_vinto.visible = true
		9:
			disable_ui()
			$UI/hai_pareggiato.visible = true
		10:
			disable_ui()
			$UI/hai_perso.visible = true
		11:
			disable_ui()
			$UI/hai_vinto.visible = true

func _on_torna_al_menu_pressed():
		get_tree().change_scene("res://scenes/Menu.tscn")

func _on_inizia_una_nuova_partita_pressed():
		get_tree().reload_current_scene()

func _on_Timer_timeout():
	if game_over == false:
		ai_computer()
		move_wait = false
