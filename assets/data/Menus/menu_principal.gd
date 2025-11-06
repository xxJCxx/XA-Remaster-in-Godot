extends Control

var animation_progress : float = 1.0
@onready var menu_night = preload("res://assets/data/Menus/Texture_menu_principal_night.tres")
@onready var menu = preload("res://assets/data/Menus/Texture_menu_principal.tres")

func _ready():
	$menu_opciones.ocultar()
	$Animacion_transicion.play("mostrar")
	if Time.get_time_dict_from_system().hour > 18 or 6 > Time.get_time_dict_from_system().hour:
		$Fondo.texture = menu_night
	else:
		$Fondo.texture = menu

func _process(delta: float) -> void:
	if $Animacion_transicion.current_animation == "mostrar":
		animation_progress -= 0.1/3
		var material_shader: ShaderMaterial = $transicion.material
		material_shader.set_shader_parameter("animation_progress", animation_progress)
	elif $Animacion_transicion.current_animation == "ocultar":
		animation_progress += 0.1/4
		var material_shader: ShaderMaterial = $transicion.material
		material_shader.set_shader_parameter("animation_progress", animation_progress)

func _input(event: InputEvent) -> void :
	if Input.is_action_just_pressed("Pausa") and $menu_opciones.activo == true and not $Ayuda.visible:
		$sfx_node.play()
		$menu_opciones.ocultar()
	elif Input.is_action_just_pressed("Pausa") and $menu_opciones.activo == false and $menu_salir_juego.activo and not $Ayuda.visible:
		$sfx_node.play()
		$menu_salir_juego.ocultar()
	elif Input.is_action_just_pressed("Pausa") and $menu_opciones.activo == false and not $menu_salir_juego.activo and not $Ayuda.visible and not $Creditos.visible:
		$sfx_node.play()
		$menu_salir_juego.mostrar()
	if Input.is_action_just_released("Pausa") and ($Ayuda.visible or $Creditos.visible):
		$sfx_node.play()
		$Ayuda.hide()
		$Creditos.hide()

func cambiar_escena():
	get_tree().change_scene_to_file("res://assets/data/Menus/menu_selección_de_nivel.tscn")

func _on_boton_jugar_pressed():
	if not $Ayuda.visible:
		Input.vibrate_handheld(30, 0.5)
		$sfx_node.play()
		$Animacion_transicion.play("ocultar")


func _on_boton_opciones_pressed() -> void :
	if not $Ayuda.visible:
		Input.vibrate_handheld(30, 0.5)
		$sfx_node.play()
		if $menu_opciones.activo == true:
			$menu_opciones.ocultar()
			$menu_opciones.activo = false
		else:
			$menu_opciones.mostrar()
			$menu_opciones.activo = true


func _on_boton_salir_pressed() -> void :
	if not $Ayuda.visible:
		Input.vibrate_handheld(30, 0.5)
		$sfx_node.play()
		$menu_salir_juego.mostrar()


func _on_boton_ayuda_pressed() -> void :
	if not $Ayuda.visible:
		Input.vibrate_handheld(30, 0.5)
		$sfx_node.play()
		$Ayuda.show()


func _on_boton_creditos_pressed() -> void :
	if not $Creditos.visible:
		Input.vibrate_handheld(30, 0.5)
		$sfx_node.play()
		$Creditos.show()


func _on_touch_ayuda_creditos_pressed() -> void :
	if $Ayuda.visible or $Creditos.visible:
		$sfx_node.play()
		$Ayuda.hide()
		$Creditos.hide()
