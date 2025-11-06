extends Control
var nivel_para_cargar
var nivel_listo = false
@onready var save = preload("res://save/save_data.json")
var nivel_actual = 1
var nivel = 0
var pos_aura
var pos_flecha
var puntaje_nivel

var animation_progress : float = 1.0

func nivel_cargado():
	nivel_listo = true

func cargar_nivel():
	get_tree().change_scene_to_file("res://assets/data/Levels/Campos_del_Oeste/campos_del_oeste.tscn")

func cambiar_escena():
	get_tree().change_scene_to_file("res://assets/data/Menus/menu_principal.tscn")

func actualizar_nivel(pos):
	$info_nivel / TiempoRecord / tiempo.text = pos_flecha[pos].tiempo_str
	$info_nivel / Nombre.text = pos_flecha[pos].nombre_nivel
	$info_nivel / Nivel.text = str(pos_flecha[pos].num_nivel)
	$info_nivel / Vacas.text = str(pos_flecha[pos].vacas_por_conseguir)
	$info_nivel / Vacas_por_conseguir.text = str(pos_flecha[pos].vacas)
	$info_nivel / Monedas.text = str(pos_flecha[pos].monedas)
	$info_nivel / Puntos.text = str(pos_flecha[pos].puntaje)
	while $info_nivel / Puntos.get_total_character_count() < 6:
		$info_nivel / Puntos.text = "0" + $info_nivel / Puntos.text

func _ready() -> void :
	save = ResourceLoader.load("user://save_data.json")
	nivel_actual = save.data.nivel_actual

	$animacion_transicion.play("mostrar")

	var i = 0
	pos_flecha = get_tree().get_nodes_in_group("botones")
	while not (pos_flecha[i].num_nivel == nivel_actual) and i == pos_flecha.size() + 1:
		i += 1
	$aura.global_position.x = pos_flecha[i].global_position.x + 54
	$aura.global_position.y = pos_flecha[i].global_position.y + 52
	pos_aura = $aura.global_position
	$aura.play("default")
	$flecha.global_position.x = pos_flecha[nivel_actual - 1].global_position.x + 54
	$flecha.global_position.y = pos_flecha[nivel_actual - 1].global_position.y + 39

	$Animacion_flecha.play("animacion")
	actualizar_nivel(nivel)
func _process(delta: float) -> void :
	
	if $animacion_transicion.current_animation == "mostrar":
		animation_progress -= 0.1/3
		var material_shader: ShaderMaterial = $transicion.material
		material_shader.set_shader_parameter("animation_progress", animation_progress)
	elif $animacion_transicion.current_animation == "ocultar":
		animation_progress += 0.1/4
		var material_shader: ShaderMaterial = $transicion.material
		material_shader.set_shader_parameter("animation_progress", animation_progress)
	
	if nivel_listo:
		cargar_nivel()
	if Input.is_anything_pressed() and nivel_listo:
		cargar_nivel()
	$aura.global_position = lerp($aura.global_position, pos_aura, 0.1)

	if Input.is_action_just_pressed("Pausa"):
		$animacion_transicion.play("ocultar")

func _on_botón_nivel_mouse_entered(extra_arg_0: int) -> void :
	if pos_flecha[extra_arg_0].desbloqueado and not nivel == extra_arg_0:
		nivel = extra_arg_0
		pos_aura.x = pos_flecha[extra_arg_0].global_position.x + 54
		pos_aura.y = pos_flecha[extra_arg_0].global_position.y + 52
		$Animacion_info_nivel.play("ocultar_mostrar")
		actualizar_nivel(extra_arg_0)


func _on_botón_nivel_pressed(extra_arg_0: String, extra_arg_1: int) -> void :
	Input.vibrate_handheld(30, 0.5)
	$animacion_transicion / TextureRect / Descripcion.text = save.data.niveles[extra_arg_1 - 1].descripcion
	$animacion_transicion / TextureRect / Nombre_nivel.text = save.data.niveles[extra_arg_1 - 1].nombre
	$animacion_transicion / TextureRect / Nivel.text = str("Nivel", extra_arg_1)
	$animacion_transicion / TextureRect / level_prev.frame = extra_arg_1 - 1
	nivel_para_cargar = extra_arg_0
	$animacion_transicion.play("cargar_nivel")


func _on_boton_atras_pressed() -> void :
	Input.vibrate_handheld(30, 0.5)
	$sfx_node.play()
	$animacion_transicion.play("ocultar")
