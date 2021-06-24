extends Sprite

export var encuentros : Array
var res_decision = load("res://scripts/menus/menuDecision.tscn")
var res_menuEstadisticas = load("res://scripts/menus/menuEstadisticas.tscn")
var menuEstadisticas
var res_menuPrincipal = load("res://scripts/menus/menuPrincipal.tscn")
var menu
var res_menuEncuentro = load("res://scripts/encuentros/menuEncuentro.tscn")
var menuEncuentro
var res_equipo = load("res://scripts/equipos/equipo.tscn")
var archivo_astorJoven = "res://scripts/personajes/astorJoven.tscn"
var res_dialogo = load("res://scripts/dialogos/dialogoEncuentro.tscn")
var dialogo

var aliados = Array()
var cantAliados = 0
var equipoAliado
var equipoRival
var diccionarioPersistencia
var encuentrosGanadosSeguidos = 0
var encuentrosGanados = 0
var encuentrosPerdidos = 0
var indiceEncuentro = -1
var encuentro
signal comenzar

func _ready():
	dialogo = res_dialogo.instance()
	dialogo.init()
	add_child(dialogo)
	dialogo.setPosicion(Vector2(640,540))
	menu = res_menuPrincipal.instance()
	menu.init(self)
	if (cargarArchivo()):
		menu.activarBotones(self)
	add_child(menu)
	menuEstadisticas = res_menuEstadisticas.instance()
	add_child(menuEstadisticas)

func crearEquipoAliado():
	equipoAliado = res_equipo.instance()
	cantAliados = 0
	for p in aliados:
		if (p != null):
			cantAliados += 1
			equipoAliado.agregarPersonaje(load(p).instance())

func siguienteEncuentro():
	guardarPartida()
	
	#Limpia los nodos del encuentro anterior
	if (menuEncuentro != null):
		menuEncuentro.queue_free()
	
	indiceEncuentro += 1
	
	if (indiceEncuentro < encuentros.size()):
		encuentro = encuentros[indiceEncuentro]
		
		crearEquipoAliado()
		
		#Crea el equipo rival
		equipoRival = res_equipo.instance()
		for p in encuentros[indiceEncuentro].getRivales():
			equipoRival.agregarPersonaje(p.instance())
		
		#Crea el menu de encuentros
		menuEncuentro = res_menuEncuentro.instance()
		menuEncuentro.connect("ganado",self,"ganar")
		menuEncuentro.connect("perdido",self,"perder")
		self.connect("comenzar",menuEncuentro,"comenzar")
		add_child(menuEncuentro)
		menuEncuentro.init(encuentro.getFondo(),encuentro.getMusica(),equipoAliado,equipoRival)
		for d in encuentro.getInicio():
			yield(dialogo.mostrar(d.getTexto(),d.getImagen()),"completed")
		emit_signal("comenzar")
		print("hola")
	else:
		print("termino el juego xd")

func ganar():
	encuentrosGanados += 1
	encuentrosGanadosSeguidos += 1
	
	for d in encuentro.getFinal():
		yield(dialogo.mostrar(d.getTexto(),d.getImagen()),"completed")
	
	yield(personajePremio(),"completed")
	
	siguienteEncuentro()

func personajePremio():
	#Posibilidad de añadir un personaje como aliado
	var decision = res_decision.instance()
	var premio
	var retorno
	premio = encuentros[indiceEncuentro].getPremio()
	if (premio != null):
		add_child(decision)
		retorno = yield(decision.elegir(aliados[0],aliados[2]),"completed")
		if (retorno != -1):
			aliados[retorno] = premio.get_path()
	yield(get_tree(),"idle_frame")

func perder():
	encuentrosPerdidos += 1
	guardarPartida()
	menuEncuentro.queue_free()
	menu.setVisible(true)
	#ACA MOSTRAR GAME OVER Y VOLVER AL MENU

func guardarPartida():
	var archivo = File.new()
	diccionarioPersistencia = {
		"indiceEncuentro":indiceEncuentro,
		"aliados":[aliados[0],aliados[1],aliados[2]],
		"estadisticas":{
			"encuentrosGanadosSeguidos":encuentrosGanadosSeguidos,
			"encuentrosGanados":encuentrosGanados,
			"encuentrosPerdidos":encuentrosPerdidos
		}
	}
	archivo.open("user://astor.save",File.WRITE)
	archivo.store_line(to_json(diccionarioPersistencia))
	archivo.close()

func cargarArchivo():
	var archivo = File.new()
	if (archivo.open("user://astor.save",File.READ) != OK):
		return false
	else:
		diccionarioPersistencia = parse_json(archivo.get_line())
		archivo.close()
		indiceEncuentro = diccionarioPersistencia.indiceEncuentro
		aliados = diccionarioPersistencia.aliados
		encuentrosGanadosSeguidos = diccionarioPersistencia.estadisticas.encuentrosGanadosSeguidos
		encuentrosGanados = diccionarioPersistencia.estadisticas.encuentrosGanados
		encuentrosPerdidos = diccionarioPersistencia.estadisticas.encuentrosPerdidos
		return true

func nuevaPartida():
	get_node("/root/Sonidos").click()
	#Avisar que se sobreescribe la partida
	indiceEncuentro = -1
	encuentrosGanadosSeguidos = 0
	aliados.clear()
	aliados.append(null)
	aliados.append(archivo_astorJoven)
	aliados.append(null)
	menu.setVisible(false)
	siguienteEncuentro()

func seguirPartida():
	get_node("/root/Sonidos").click()
	menu.setVisible(false)
	siguienteEncuentro()

func abrirEstadisticas():
	var mensajeBueno
	var mensajeMalo
	get_node("/root/Sonidos").click()
	mensajeBueno = str("Encuentros ganados seguidos: ",encuentrosGanadosSeguidos,"\nEncuentros ganados totales: ",encuentrosGanados)
	menuEstadisticas.setTextoBueno(mensajeBueno)
	mensajeMalo = str("Encuentros perdidos totales: ",encuentrosPerdidos)
	menuEstadisticas.setTextoMalo(mensajeMalo)
	menu.setVisible(false)
	yield(menuEstadisticas.abrir(),"completed")
	menu.setVisible(true)
