extends Node2D

var save_data = JSON.new()

var config_file = ConfigFile.new()
var turn_music = true
var comienzo = false
var player
var Pausa = false
var Obj_Pause = false
var monedas
var vacas

func guardar_datos():
    save_data = ResourceLoader.load("user://save_data.json")
    if save_data.data.niveles[0].monedas < player.monedas:
        save_data.data.niveles[0].monedas = player.monedas * 100 / monedas
    if save_data.data.niveles[0].vacas < player.vacas_rescatadas:
        save_data.data.niveles[0].vacas = player.vacas_rescatadas
    if not save_data.data.niveles[0].tiempoX < player.tiempo.x:
        save_data.data.niveles[0].tiempoX = player.tiempo.x
        save_data.data.niveles[0].tiempoY = player.tiempo.y
        save_data.data.niveles[0].tiempo_str = player.cont_tiempo
    if save_data.data.niveles[0].puntos < player.contador_puntos:
        save_data.data.niveles[0].puntos = player.contador_puntos
    ResourceSaver.save(save_data, "user://save_data.json")

func _ready():
    player = get_tree().get_first_node_in_group("player")

    save_data = ResourceLoader.load("user://save_data.json")
    $XA.vidas = save_data.data.vidas
    $XA.mod_vidas(0)

    $Collision_tiles.tile_set = load("res://assets/data/TileSets/Tileset_backup.tres")
    $Elements_tiles.tile_set = load("res://assets/data/TileSets/Tileset_backup.tres")
    $Collision_tiles.enabled = true
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    if monedas:
        player.porcentaje_monedas = player.monedas * 100 / monedas

    player.Camera.limit_right = $Final.global_position.x
    monedas = get_tree().get_nodes_in_group("monedas").size()
    vacas = get_tree().get_nodes_in_group("vacas").size()


func _process(_delta):




    if Input.is_action_just_pressed("Pausa") and $XA.fin == false and $MenuPausa.ayuda_activada == false:
        pausar_despausar( not $MenuPausa.Menu_Activado)

    if player.death == true:
        $Music_node.stop()
        turn_music = false
    elif turn_music == false:
        $Music_node.play()
        turn_music = true
    if monedas:
        player.porcentaje_monedas = player.monedas * 100 / monedas
    if vacas:
        player.actualizar_vacas_restantes(vacas)

func pausar_despausar(pausa):
    if pausa == false:
        Obj_Pause = false
        player.process_mode = Node.PROCESS_MODE_INHERIT
        for i in get_child_count():
            get_child(i).process_mode = Node.PROCESS_MODE_INHERIT
    elif pausa == true:
        Obj_Pause = true
        for i in get_child_count():
            player.process_mode = Node.PROCESS_MODE_DISABLED
            if get_child(i).is_in_group("enemigo") or get_child(i).is_in_group("monedas"):
                get_child(i).process_mode = Node.PROCESS_MODE_DISABLED
