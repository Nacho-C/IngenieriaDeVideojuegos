extends Node2D

var timer = 0.0
var timerRunning = true
var respeto : int = 0
export var nombre : String
export var creatividad : int
export var talento : int
export var autoestima : int
export var dedosRapidos : int
var direccion
var habilidades

signal bastaParaMi

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
	
func getHabilidades():
	$Habilidades.getHabilidades()

func usarHabilidad(objetivo,habilidad):
	habilidad.ejecutar(self,objetivo);

func getNombre():
	return self.nombre

func getRespeto():
	return self.respeto

func alterarRespeto(monto):
	pass

func getTalento():
	return self.talento

func alterarTalento(monto):
	pass

func getCreatividad():
	return self.creatividad

func alterarCreatividad(monto):
	pass

func getAutoestima():
	return self.autoestima

func alterarAutoestima(monto):
	pass

func getDedosRapidos():
	return self.dedosRapidos

func alterarDedosRapidos(monto):
	self.dedosRapidos = self.dedosRapidos + monto
	if (self.dedosRapidos < 0):
		self.dedosRapidos = 0

func addHabilidad(habilidad):
	$Habilidades.addHabilidad(habilidad)
