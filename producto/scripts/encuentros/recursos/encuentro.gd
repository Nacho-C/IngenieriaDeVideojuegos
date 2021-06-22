extends Resource

class_name encuentro

export var musica : AudioStreamMP3
export var fondo : Texture
export var rivales : Array
export var dialogoInicial : Array
export var dialogoFinal : Array

func getRivales():
	return rivales

func getFondo():
	return fondo

func getMusica():
	return musica
