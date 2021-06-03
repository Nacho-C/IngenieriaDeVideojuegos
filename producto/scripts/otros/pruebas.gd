extends Sprite

var menuEncuentro = load("res://scripts/encuentros/menuEncuentro.tscn")
var equipo = load("res://scripts/equipos/equipo.tscn")
var personaje = load("res://scripts/personajes/personaje.tscn")
var astor = load("res://scripts/personajes/astor.tscn")
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
	p1b = astor.instance()
	p1c = personaje.instance()
	e1.agregarPersonaje(p1b)
	e1.agregarPersonaje(p1a)
	e1.agregarPersonaje(p1c)
	
	#Generación de equipo 2
	e2 = equipo.instance()
	p2a = personaje.instance()
	p2b = personaje.instance()
	e2.agregarPersonaje(p2a)
	e2.agregarPersonaje(p2b)
	
	encuentro = menuEncuentro.instance()
	add_child(encuentro)
	encuentro.position = Vector2(-640,-360)
	encuentro.init(e1,e2)
