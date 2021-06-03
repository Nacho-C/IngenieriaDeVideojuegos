extends Node

export var habilidades : Array

func getHabilidades():
	return habilidades

func addHabilidad(habilidad):
	self.habilidades.append(habilidad)
