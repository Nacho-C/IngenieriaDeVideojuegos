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

signal bastaParaMi
signal seleccionado
signal terminarTurno

func _ready():
	yield(animarCreatividad(),"completed")

#Actualiza el timer y la creatividad en cada frame
func _process(delta):
	if (timerRunning):
		timer += delta*dedosRapidos
		creatividad += delta*creatividadInicial/10
		if creatividad > creatividadInicial:
			creatividad = creatividadInicial
		$BarraCreatividad.value = 100 * creatividad / creatividadInicial
		if (self.timer >= 100):
			timer = 100
			timerRunning = false
			emit_signal("bastaParaMi")
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
	yield(animarCreatividad(),"completed")
	return yield(habilidad.ejecutar(self,objetivo),"completed")

func animarCreatividad():
	var objetivo = 100 * creatividad / creatividadInicial
	var paso = abs($BarraCreatividad.value - objetivo) / 25
	var signo = sign($BarraCreatividad.value - objetivo) * (-1)
	while abs($BarraCreatividad.value - objetivo) > paso:
		$BarraCreatividad.value += paso * signo
		yield(get_tree(),"idle_frame")
	$BarraCreatividad.value = objetivo
	yield(get_tree(),"idle_frame")

func animarTimer():
	var paso = abs($Timer.value - timer) / 25
	var signo = sign($Timer.value - timer) * (-1)
	while abs($Timer.value - timer) > paso:
		$Timer.value += paso * signo
		yield(get_tree(),"idle_frame")
	$Timer.value = timer
	yield(get_tree(),"idle_frame")

#Altera una estadística cuando el personaje recibe una habilidad
func alterarStat(monto,stat):
	var retorno = monto
	var resultado = monto
	match stat:
		"Respeto": 
			if (-monto > autoestima):
				retorno = monto + autoestima
				respeto -= retorno
			else:
				retorno = 0
		"Talento": 
			if (talento + monto > 0):
				talento += monto
			else:
				talento = 0
		"Creatividad": 
			if (creatividad + monto > 0):
				creatividad += monto
			else:
				creatividad = 0
			yield(animarCreatividad(),"completed")
		"Autoestima": 
			if (autoestima + monto > 0):
				autoestima += monto
			else:
				autoestima = 0
		"Dedos Rápidos": 
			if (dedosRapidos + monto > 0):
				dedosRapidos += monto
			else:
				dedosRapidos = 0
		"Reloj":
			timer += monto
			if (timer < 0):
				timer = 0
			else:
				if (timer > 100):
					timer = 100
			yield(animarTimer(),"completed")
	yield(get_tree(),"idle_frame")
	return retorno

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
