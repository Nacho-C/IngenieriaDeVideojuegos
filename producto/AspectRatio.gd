extends Node

onready var viewport = get_viewport()

func _ready():
	#Conecta la señal que envía el viewport al cambiar de tamaño con la función
	#change_aspect_ratio
	viewport.connect("size_changed",self,"change_aspect_ratio")
	#Llama por primera vez a change_aspect_ratio para inicializar la pantalla
	change_aspect_ratio()
	
func change_aspect_ratio():
	var scale #Relación entre tamaño mínimo y real
	var new_size #Tamaño adaptado de la vista
	var margin #Margen para centrar la pantalla
	var min_size = Vector2(1280,720) #Tamaño mínimo de la vista diseñada
	var min_ratio = min_size.x / min_size.y #Relación de aspecto mínima
	var real_size = OS.get_window_size() #Tamaño real de la pantalla
	var real_ratio = real_size.x / real_size.y #Relación de aspecto real
	
	if (real_ratio >= min_ratio): #Se mantiene el alto fijo
		scale = min_size.y / real_size.y
		new_size = Vector2(real_size.x*scale,min_size.y)
		margin = Vector2((new_size.x-min_size.x)/2, 0)
	else: #Se mantiene el ancho fijo
		scale = min_size.x / real_size.x
		new_size = Vector2(min_size.x,real_size.y*scale)
		margin = Vector2(0, (new_size.y-min_size.y)/2)
	viewport.set_size_override(true,min_size,margin)
