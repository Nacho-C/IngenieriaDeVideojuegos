extends Resource

class_name habilidad

export var nombre : String
export var costo : int
export(String,"respeto","talento","creatividad","autoestima","dedosRapidos") var statBase
export var multiplicador : float
export(String,"Respeto","Talento","Creatividad","Autoestima","Dedos Rápidos","Reloj") var statObjetivo
export(String,"aliados","enemigos") var equipoAfectado

func getNombre():
	return nombre

func getEquipoAfectado():
	match equipoAfectado:
		"aliados": return 1
		"enemigos": return 2

func getCosto():
	return costo

func getStatObjetivo():
	return statObjetivo

func getMultiplicador():
	return multiplicador

func ejecutar(fuente,objetivo):
	var monto
	match statBase:
		"respeto": monto = fuente.getRespeto()
		"talento": monto = fuente.getTalento()
		"creatividad": monto = fuente.getCreatividad()
		"autoestima": monto = fuente.getAutoestima()
		"dedosRapidos": monto = fuente.getDedosRapidos()
	monto = monto * multiplicador
	return yield(objetivo.alterarStat(monto,statObjetivo),"completed")
