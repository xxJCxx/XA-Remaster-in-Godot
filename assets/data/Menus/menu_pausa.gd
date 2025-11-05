extends Control

var config_file = ConfigFile.new()
var ayuda_activada = false
var Menu_Activado = false

func desactivar_botones():
    $CanvasLayer / Menu / Boton_Jugar.disabled = true
    $CanvasLayer / Menu / Boton_Salir.disabled = true
    $CanvasLayer / Menu / Boton_Ayuda.disabled = true
    $CanvasLayer / Menu / Boton_Opciones.disabled = true

func activar_botones():
    $CanvasLayer / Menu / Boton_Jugar.disabled = false
    $CanvasLayer / Menu / Boton_Salir.disabled = false
    $CanvasLayer / Menu / Boton_Ayuda.disabled = false
    $CanvasLayer / Menu / Boton_Opciones.disabled = false

func JuegoPausado():
    pass

func actualizar_config(new_vol_musica, new_vol_sfx, pantalla_completa):

    $CanvasLayer / click_sfx.volume_db = new_vol_sfx
    config_file.load("user://config.cfg")
    config_file.set_value("volumen", "vol_musica", new_vol_musica)
    config_file.set_value("volumen", "vol_sfx", new_vol_sfx)
    config_file.set_value("Video", "pantalla_completa", pantalla_completa)
    config_file.save("user://config.cfg")

func _ready():
    $menu_opciones.Fondo_Borroso.visible = false
    $menu_salir_principal.position.y = 1500
    $menu_salir_principal.ocultar()
    $Animaciones.play("Des_Pausa")


func _process(_delta):
    if Menu_Activado:
        if $menu_opciones.activo == true or not $menu_salir_principal.oculto:
            $CanvasLayer / Menu.hide()
            desactivar_botones()
        else:
            $CanvasLayer / Menu.show()
            activar_botones()

    if Input.is_action_just_pressed("Pausa") and $"../XA".fin == false and not ayuda_activada:
        if Menu_Activado == false:
            Input.vibrate_handheld(30, 0.5)
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            Menu_Activado = true
        elif Menu_Activado == true and not $menu_opciones.activo:
            Input.vibrate_handheld(30, 0.5)
            Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
            Menu_Activado = false

    if Input.is_action_just_pressed("Pausa") and $"../XA".fin == false and Menu_Activado == false and $menu_opciones.activo == false and not ayuda_activada:
        Input.vibrate_handheld(30, 0.5)
        $Animaciones.play("Des_Pausa")
    elif Input.is_action_just_pressed("Pausa") and $"../XA".fin == false and Menu_Activado == true and $menu_opciones.activo == true and not ayuda_activada:
        Input.vibrate_handheld(30, 0.5)
        $menu_opciones.ocultar()
        $sfx_node.play()
    elif Input.is_action_just_pressed("Pausa") and $"../XA".fin == false and Menu_Activado == true and not ayuda_activada:
        Input.vibrate_handheld(30, 0.5)
        $CanvasLayer.visible = true
        $Animaciones.play("Act_Pausa")
    if Input.is_action_just_pressed("Pausa") and ayuda_activada:
        Input.vibrate_handheld(30, 0.5)
        ayuda_activada = false
        $sfx_node.play()
        $Animaciones.play("Des_Ayuda")

func _on_boton_salir_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    if not ayuda_activada:
        $sfx_node.play()
        $menu_salir_principal.mostrar()


func _on_boton_jugar_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    if not ayuda_activada:
        $"..".pausar_despausar(false)
        Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
        $sfx_node.play()
        Menu_Activado = false
        $Animaciones.play("Des_Pausa")


func _on_boton_opciones_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    if not ayuda_activada:
        $sfx_node.play()
        if $menu_opciones.activo == true:
            $menu_opciones.ocultar()
        else:
            $menu_opciones.mostrar()


func _on_boton_ayuda_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    if not ayuda_activada:
        $sfx_node.play()
        desactivar_botones()
        $Animaciones.play("Act_Ayuda")
        ayuda_activada = true


func _on_touch_ayuda_pressed() -> void :
    if ayuda_activada:
        ayuda_activada = false
        $sfx_node.play()
        $Animaciones.play("Des_Ayuda")
