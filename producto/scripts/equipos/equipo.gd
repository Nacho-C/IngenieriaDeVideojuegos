extends Node2D

const pos1 = Vector2(0,0)
const pos2a = Vector2(0,-75)
const pos2b = Vector2(0,75)
const pos3a = Vector2(0,-150)
const pos3b = Vector2(0,150)

var personajes = Array()

func _ready():
	pass

func agregarPersonaje(personaje):
	personajes.append(personaje)
	add_child(personaje)
	posicionesPersonajes()
	
func posicionesPersonajes():
	if (personajes.size() == 1):
		personajes[0].position = pos1
	elif (personajes.size() == 2):
		personajes[0].position = pos2a
		personajes[1].position = pos2b
	elif (personajes.size() == 3):
		personajes[0].position = pos1
		personajes[1].position = pos3a
		personajes[2].position = pos3b
		
func getPersonajes():
	return personajes
	
func setDireccion(dir):
	for p in personajes:
		p.setDireccion(dir)

func getRespeto():
	var respeto = 0
	for p in personajes:
		respeto += p.getRespeto()
	return respeto
