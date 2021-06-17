extends Node2D

func init(personaje,menu):
	var i = 0
	var habilidades = personaje.getHabilidades()
	var habilidad
	var label
	for c in $Marco.get_children():
		if (c is TouchScreenButton):
			if (habilidades.size() >= i+1):
				habilidad = habilidades[i]
				label = c.get_node("Label")
				label.set_text(str(habilidad.getNombre()," (",habilidad.getCosto(),")"))
				if (personaje.getCreatividad() >= habilidad.getCosto()):
					c.connect("released",menu,"mostrarObjetivos",[habilidad])
				else:
					label.add_color_override("font_color",Color(0.41,0.41,0.41,1))
				i = i + 1
