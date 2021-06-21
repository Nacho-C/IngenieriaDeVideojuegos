extends Node2D

const pos1 = Vector2(0,0)
const pos2a = Vector2(0,-100)
const pos2b = Vector2(0,100)
const pos3a = Vector2(0,-200)
const pos3b = Vector2(0,200)

var personajes = Array()

func agregarPersonaje(personaje):
	personajes.append(personaje)
	add_child(personaje)
	posicionesPersonajes()

#Setea las posiciones relativas de cada personaje en función del tamaño del equipo
func posicionesPersonajes():
	if (personajes.size() == 1):
		personajes[0].position = pos1
	elif (personajes.size() == 2):
		personajes[0].position = pos2a
		personajes[1].position = pos2b
	elif (personajes.size() == 3):
		personajes[0].position = pos3a
		personajes[1].position = pos1
		personajes[2].position = pos3b

func getPersonajes():
	return personajes

#Cambia la dirección a la que apuntan los personajes del equipo
# 1: hacia la derecha, -1: hacia la izquierda
func setDireccion(dir):
	for p in personajes:
		p.setDireccion(dir)

#Devuelve la sumatoria de respetos de todos los personajes del equipo
#El p.getRespeto() de cada personaje corresponde al respeto que le tiene al otro equipo
func getRespeto():
	var respeto = 0
	for p in personajes:
		respeto += p.getRespeto()
	if (respeto >= 100):
		respeto = 100
	return respeto
