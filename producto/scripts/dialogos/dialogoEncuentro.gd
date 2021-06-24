extends Node2D

signal ocultado

func init():
	$Canvas/Marco/BotonDialogo.connect("released",self,"ocultar")
	$Canvas/Marco.set_visible(false)

func mostrar(mensaje, imagen):
	if (imagen == null):
		$Canvas/Marco/Imagen.set_visible(false)
	else:
		$Canvas/Marco/Imagen.set_texture(imagen)
		$Canvas/Marco/Imagen.set_visible(true)
	get_node("/root/Sonidos").mensaje()
	get_tree().paused = true
	$Canvas/Marco/Texto.set_text(mensaje)
	$Canvas/Marco.set_visible(true)
	yield(self,"ocultado")

func ocultar():
	get_node("/root/Sonidos").click()
	$Canvas/Marco.set_visible(false)
	get_tree().paused = false
	emit_signal("ocultado")

func setPosicion(posicion):
	$Canvas.offset = posicion
