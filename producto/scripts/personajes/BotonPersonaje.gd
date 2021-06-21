extends TouchScreenButton

var activado

signal seleccionado
signal terminarTurno

func _ready():
	#Crea un área del tamaño y posición del sprite del personaje
	var sprite = self.get_parent()
	var size = sprite.get_texture().get_size()
	var rectangulo = RectangleShape2D.new()
	rectangulo.set_extents(size / 2)
	self.set_shape(rectangulo)
	
	#Conecta el botón con el personaje
	self.connect("released",self,"toque")
	self.connect("seleccionado",sprite.get_parent(),"seleccionar")
	self.connect("terminarTurno",sprite.get_parent(),"s_terminarTurno")
	activado = 0

#0: desactivado, 1: seleccionable, 2: seleccionado
func setActivado(valor):
	activado = valor

#Emite la señal correspondiente al tocar el botón
func toque():
	if (activado != 0):
		get_node("/root/Sonidos").click()
		if (activado == 1):
			emit_signal("seleccionado")
		elif (activado == 2):
			emit_signal("terminarTurno")
