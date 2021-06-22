extends Node

var res_click = preload("res://assets/sounds/toque.wav")
var click
var res_mensaje = preload("res://assets/sounds/mensaje.wav")
var mensaje
var musica
var tiempoMusica

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	click = AudioStreamPlayer.new()
	add_child(click)
	click.stream = res_click
	mensaje = AudioStreamPlayer.new()
	add_child(mensaje)
	mensaje.stream = res_mensaje
	musica = AudioStreamPlayer.new()
	add_child(musica)
	musica.volume_db = -5

func click():
	click.play()

func mensaje():
	if (!click.playing):
		mensaje.play()

func empezarMusica(mp3):
	musica.stream = mp3
	musica.play(0)

func seguirMusica():
	if (!musica.playing):
		musica.play(tiempoMusica)

func pararMusica():
	musica.stop()
	tiempoMusica = musica.get_playback_position()
