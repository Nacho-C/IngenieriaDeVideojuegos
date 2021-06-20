extends Node2D

var equipo
var timer = 0.0
var timerRunning = false
var respeto : int = 0
export var nombre : String
export var creatividadInicial : int
onready var creatividad = creatividadInicial
export var talento : int
export var autoestima : int
export var dedosRapidos : int
var direccion
var habilidades
var animandoCreatividad = false
var animandoTimer = false

signal bastaParaMi
signal seleccionado
signal terminarTurno

func _ready():
	animarCreatividad()

#Actualiza el timer y la creatividad en cada frame
func _process(delta):
	if (timerRunning):
		timer += delta*dedosRapidos
		creatividad += delta*creatividadInicial/10
		if creatividad > creatividadInicial:
			creatividad = creatividadInicial
		if !animandoCreatividad:
			$BarraCreatividad.value = 100 * creatividad / creatividadInicial
		if (self.timer >= 100):
			timer = 100
			timerRunning = false
			emit_signal("bastaParaMi")
		if !animandoTimer:
			$Timer.value = timer

func setEquipo(equipo):
	self.equipo = equipo
	if (equipo == 1):
		$IndicadorSeleccionable.set_modulate(Color(0.3,1,0.5))
	else:
		$IndicadorSeleccionable.set_modulate(Color(1,0.3,0.3))

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

#PRE: creatividad >= habilidad.getCosto()
func usarHabilidad(objetivo,habilidad):
	creatividad -= habilidad.getCosto()
	animarCreatividad()
	habilidad.ejecutar(self,objetivo)

func animarCreatividad():
	animandoCreatividad = true
	var paso = 1/6
	var signo
	if ($BarraCreatividad.value > (100 * creatividad / creatividadInicial)):
		signo = -1
	else:
		signo = 1
	if (abs($BarraCreatividad.value - (100 * creatividad / creatividadInicial)) > paso * 30):
		paso = abs($BarraCreatividad.value - (100 * creatividad / creatividadInicial)) / 30
	while true:
		if abs($BarraCreatividad.value - (100 * creatividad / creatividadInicial)) > paso:
			$BarraCreatividad.value += paso * signo
			yield(get_tree(),"idle_frame")
		else:
			animandoCreatividad = false
			return

func animarTimer():
	animandoTimer = true
	var paso = 1/6
	var signo
	if ($Timer.value > timer):
		signo = -1
	else:
		signo = 1
	if (abs($Timer.value - timer) > paso * 30):
		paso = abs($Timer.value - timer) / 30
	while true:
		if abs($Timer.value - timer) > paso:
			$Timer.value += paso * signo
			yield(get_tree(),"idle_frame")
		else:
			animandoTimer = false
			return

#Altera una estadística cuando el personaje recibe una habilidad
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
			animarCreatividad()
		"autoestima": 
			if (autoestima + monto > 0):
				autoestima += monto
		"dedosRapidos": 
			if (dedosRapidos + monto > 0):
				dedosRapidos += monto
		"timer":
			timer += monto
			if (timer < 0):
				timer = 0
			else:
				if (timer > 100):
					timer = 100
			animarTimer()

func getNombre():
	return nombre

func getRespeto():
	return respeto

func getTalento():
	return talento

func getCreatividad():
	return creatividad

func getAutoestima():
	return autoestima

func getDedosRapidos():
	return dedosRapidos

func addHabilidad(habilidad):
	$Habilidades.addHabilidad(habilidad)

#Envía una señal al encuentro cuando se debe posicionar el cursor sobre el personaje
func seleccionar():
	emit_signal("seleccionado")

#Envía una señal al encuentro cuando se debe aplicar una habilidad al personaje
func s_terminarTurno():
	emit_signal("terminarTurno")

#Cambia el estado del botón táctil del personaje
func setActivadoBoton(valor):
	#Activar indicador "seleccionable"
	if (valor != 0):
		$IndicadorSeleccionable.set_visible(true)
	else:
		$IndicadorSeleccionable.set_visible(false)
	$Sprite/BotonPersonaje.setActivado(valor)

#Devuelve la posición del cursor de acuerdo a la posición y tamaño del personaje
func getPosicionFlecha():
	var offsetX = ($Sprite.texture.get_width() * $Sprite.transform.get_scale().x / 2) + 10
	var retorno = self.position
	retorno.x += direccion * -1 * offsetX
	return retorno
