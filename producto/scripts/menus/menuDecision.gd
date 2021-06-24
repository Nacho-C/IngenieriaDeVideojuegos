extends Node2D

signal selecciono
var seleccionado

func _ready():
	$Marco/Boton1.connect("released",self,"cero")
	$Marco/Boton2.connect("released",self,"dos")
	$Marco/BotonNoReemplazar.connect("released",self,"ninguno")

func elegir(p1,p2):
	var aux
	if (p1 != null):
		aux = load(p1).instance()
		$Marco/Boton1/Sprite1.set_texture(aux.getTextura())
	if (p2 != null):
		aux = load(p2).instance()
		$Marco/Boton2/Sprite2.set_texture(aux.getTextura())
	yield(self,"selecciono")
	return seleccionado

func cero():
	seleccionado = 0
	emit_signal("selecciono")

func dos():
	seleccionado = 2
	emit_signal("selecciono")

func ninguno():
	seleccionado = -1
	emit_signal("selecciono")
