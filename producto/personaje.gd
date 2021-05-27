extends Node2D

var timer = 0.0
var timerRunning = true
var dedosRapidos
var direccion

signal bastaParaMi

func init(velocidad):
	dedosRapidos = velocidad

func _ready():
	pass
	
func _process(delta):
	if (timerRunning):
		timer += delta*dedosRapidos
		$Timer.set_text(String(int(timer)))
		if (timer >= 100):
			emit_signal("bastaParaMi")
			timerRunning = false

func detenerTimer():
	timerRunning = false
	
func retomarTimer():
	timerRunning = true
	
func comenzarTimer():
	timer = 0
	timerRunning = true
	
# 1: hacia la derecha, -1: hacia la izquierda
func setDireccion(dir):
	if (dir == 1):
		direccion = 1
		$Sprite.set_flip_h(false)
	else:
		direccion = -1
		$Sprite.set_flip_h(true)
		
func getDireccion():
	return direccion
