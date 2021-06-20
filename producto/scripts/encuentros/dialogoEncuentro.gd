extends Node2D

signal ocultado

func init():
	$Marco/BotonDialogo.connect("released",self,"ocultar")

func mostrar(mensaje):
	get_tree().paused = true
	$Marco/Texto.set_text(mensaje)
	self.set_visible(true)
	yield(self,"ocultado")

func ocultar():
	self.set_visible(false)
	get_tree().paused = false
	emit_signal("ocultado")
