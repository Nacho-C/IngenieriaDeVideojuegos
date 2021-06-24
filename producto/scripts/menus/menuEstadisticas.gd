extends Node2D

signal volvio

func _ready():
	$Marcos/BotonVolver.connect("released",self,"volver")

func setTextoBueno(texto):
	$Marcos/LabelBueno.set_text(texto)

func setTextoMalo(texto):
	$Marcos/LabelMalo.set_text(texto)

func volver():
	get_node("/root/Sonidos").click()
	self.set_visible(false)
	emit_signal("volvio")

func abrir():
	self.set_visible(true)
	yield(self,"volvio")
