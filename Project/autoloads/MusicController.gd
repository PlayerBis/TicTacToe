extends Node

var selezione = load("res://sound_effect/Selezione.wav")
var vittoria = load("res://sound_effect/Vittoria.wav")
var sconfitta = load("res://sound_effect/Sconfitta.wav")
var quit = load("res://sound_effect/Quit.wav")
var start = load("res://sound_effect/Start.wav")
var pareggio = load("res://sound_effect/Pareggio.wav")
var global_music = load("res://sound_effect/GlobalMusic.mp3")

func _ready():
	MusicController.play_global_music()

func play_selezione_music():
	$Music.volume_db = -10
	$Music.stream = selezione
	$Music.play()

func play_vittoria_music():
	$Music.volume_db = 2
	$Music.stream = vittoria
	$Music.play()
	
func play_sconfitta_music():
	$Music.volume_db = 2
	$Music.stream = sconfitta
	$Music.play()

func play_quit_music():
	$Music.volume_db = 2
	$Music.stream = quit
	$Music.play()
	
func play_start_music():
	$Music.volume_db = 2
	$Music.stream = start
	$Music.play()

func play_pareggio_music():
	$Music.volume_db = 2
	$Music.stream = pareggio
	$Music.play()

func play_global_music():
	$GlobalMusic.volume_db = 0
	$GlobalMusic.stream = global_music
	$GlobalMusic.play()

