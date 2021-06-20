extends Sprite

export var menuEncuentro : Resource
var equipo = load("res://scripts/equipos/equipo.tscn")
var personaje = load("res://scripts/personajes/personaje.tscn")
var res_astor = load("res://scripts/personajes/astor.tscn")
var res_nadia = load("res://scripts/personajes/nadia.tscn")
var res_anibal = load("res://scripts/personajes/anibal.tscn")
var e1
var p1a
var p1b
var e2
var p2a
var encuentro

func _ready():
	var fondo = load("res://assets/img/Playa-Background.png")
	
	#Creación de equipo 1
	e1 = equipo.instance()
	p1a = res_anibal.instance()
	p1b = res_astor.instance()
	e1.agregarPersonaje(p1b)
	e1.agregarPersonaje(p1a)
	
	#Creación de equipo 2
	e2 = equipo.instance()
	p2a = res_nadia.instance()
	e2.agregarPersonaje(p2a)
	
	#Creación de encuentro
	encuentro = menuEncuentro.instance()
	add_child(encuentro)
	encuentro.init(fondo,e1,e2)
