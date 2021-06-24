extends Node2D

func init(controlador):
	$Marcos/BotonNueva.connect("released",controlador,"nuevaPartida")

func activarBotones(controlador):
	$Marcos/BotonSeguir/Label.add_color_override("font_color",Color(1,1,1,1))
	$Marcos/BotonSeguir.connect("released",controlador,"seguirPartida")
	$Marcos/BotonEstadisticas/Label.add_color_override("font_color",Color(1,1,1,1))
	$Marcos/BotonEstadisticas.connect("released",controlador,"abrirEstadisticas")

func setVisible(valor):
	self.set_visible(valor)
