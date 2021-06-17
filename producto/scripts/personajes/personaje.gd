extends Node2D

var equipo
var timer = 0.0
var timerRunning = true
var respeto : int = 0
export var nombre : String
export var creatividadInicial : int
onready var creatividad = creatividadInicial
export var talento : int
export var autoestima : int
export var dedosRapidos : int
var direccion
var habilidades

signal bastaParaMi
signal seleccionado
signal terminarTurno

func _process(delta):
	if (self.timerRunning):
		self.timer += delta*dedosRapidos
		self.creatividad += delta*creatividadInicial/10
		if (self.creatividad > self.creatividadInicial):
			self.creatividad = self.creatividadInicial
		if (self.timer >= 100):
			self.timer = 100
			timerRunning = false
			emit_signal("bastaParaMi")
		$Timer.set_text(String(int(timer)))

func setEquipo(equipo):
	self.equipo = equipo

func getEquipo():
	return equipo

func detenerTimer():
	timerRunning = false
	
func retomarTimer():
	timerRunning = true

func comenzarTimer():
	timer = 0
	
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
	return $Habilidades.getHabilidades()

func usarHabilidad(objetivo,habilidad):
	self.creatividad -= habilidad.getCosto()
	habilidad.ejecutar(self,objetivo);

func getNombre():
	return self.nombre

func getRespeto():
	return self.respeto

func getTalento():
	return self.talento

func getCreatividad():
	return self.creatividad

func getAutoestima():
	return self.autoestima

func getDedosRapidos():
	return self.dedosRapidos
	
func alterarStat(monto,stat):
	var resultado = monto
	match stat:
		"respeto": 
			if (-monto > autoestima):
				respeto -= (monto + autoestima)
		"talento": 
			if (talento + monto > 0):
				talento += monto
		"creatividad": 
			if (creatividad + monto > 0):
				creatividad += monto
		"autoestima": 
			if (autoestima + monto > 0):
				autoestima += monto
		"dedosRapidos": 
			if (dedosRapidos + monto > 0):
				dedosRapidos += monto
		"timer":
			self.timer += monto
			if (self.timer < 0):
				self.timer = 0
			else:
				if (self.timer > 100):
					self.timer = 100

func addHabilidad(habilidad):
	$Habilidades.addHabilidad(habilidad)

func seleccionar():
	emit_signal("seleccionado")

func s_terminarTurno():
	emit_signal("terminarTurno")

func setActivadoBoton(valor):
	$Sprite/BotonPersonaje.setActivado(valor)

func getPosicionFlecha():
	var offsetX = ($Sprite.texture.get_width() * $Sprite.transform.get_scale().x / 2) + 10
	var retorno = self.position
	retorno.x += direccion * -1 * offsetX
	return retorno
