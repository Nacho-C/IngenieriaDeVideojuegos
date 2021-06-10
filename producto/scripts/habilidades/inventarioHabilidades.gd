extends Node2D

func init(habilidades,menu):
	var i = 0
	for c in $Marco.get_children():
		if (c is TouchScreenButton):
			if (habilidades.size() >= i+1):
				c.get_node("Label").set_text(habilidades[i].getNombre())
				c.connect("released",menu,"mostrarObjetivos",[habilidades[i]])
				i = i + 1
