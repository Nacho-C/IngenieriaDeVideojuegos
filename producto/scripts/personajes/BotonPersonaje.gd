extends TouchScreenButton

var activado

signal seleccionado
signal terminarTurno

func _ready():
	var sprite = self.get_parent()
	var size = sprite.get_texture().get_size()
	var rectangulo = RectangleShape2D.new()
	rectangulo.set_extents(size / 2)
	self.set_shape(rectangulo)
	self.connect("released",self,"toque")
	self.connect("seleccionado",sprite.get_parent(),"seleccionar")
	self.connect("terminarTurno",sprite.get_parent(),"s_terminarTurno")
	self.activado = 0

func setActivado(valor):
	self.activado = valor

func toque():
	if (self.activado == 1):
		emit_signal("seleccionado")
	elif (self.activado == 2):
		emit_signal("terminarTurno")
