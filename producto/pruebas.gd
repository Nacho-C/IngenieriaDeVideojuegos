extends Sprite

var menuEncuentro = load("res://menuEncuentro.tscn")
var equipo = load("res://equipo.tscn")
var personaje = load("res://personaje.tscn")
var e1
var p1a
var p1b
var p1c
var e2
var p2a
var p2b
var encuentro


func _ready():
	#Generación de equipo 1
	e1 = equipo.instance()
	p1a = personaje.instance()
	p1a.init(12)
	p1b = personaje.instance()
	p1b.init(33)
	p1c = personaje.instance()
	p1c.init(27)
	e1.agregarPersonaje(p1b)
	e1.agregarPersonaje(p1a)
	e1.agregarPersonaje(p1c)
	
	#Generación de equipo 2
	e2 = equipo.instance()
	p2a = personaje.instance()
	p2a.init(39)
	p2b = personaje.instance()
	p2b.init(17)
	e2.agregarPersonaje(p2a)
	e2.agregarPersonaje(p2b)
	
	encuentro = menuEncuentro.instance()
	add_child(encuentro)
	encuentro.position = Vector2(-640,-360)
	encuentro.init(e1,e2)
