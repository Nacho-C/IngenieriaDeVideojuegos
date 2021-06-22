extends Sprite

export var encuentros : Array
var res_menuEncuentro = load("res://scripts/encuentros/menuEncuentro.tscn")
var equipo = load("res://scripts/equipos/equipo.tscn")
var personaje = load("res://scripts/personajes/personaje.tscn")
var res_astor = load("res://scripts/personajes/astor.tscn")
var res_anibal = load("res://scripts/personajes/anibal.tscn")
var e1
var p1a
var p1b
var p1c
var e2
var menuEncuentro

func _ready():	
	var i = 2
	#Creación de equipo
	e1 = equipo.instance()
	p1a = res_anibal.instance()
	p1b = res_astor.instance()
	e1.agregarPersonaje(p1b)
	e1.agregarPersonaje(p1a)
	
	#Creación de equipo 2
	e2 = equipo.instance()
	for p in encuentros[i].getRivales():
		e2.agregarPersonaje(p.instance())
	
	#Creación de encuentro
	menuEncuentro = res_menuEncuentro.instance()
	add_child(menuEncuentro)
	menuEncuentro.init(encuentros[i].getFondo(),encuentros[i].getMusica(),e1,e2)
