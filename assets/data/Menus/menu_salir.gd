extends Control

var oculto = true

func _ready() -> void :
    $CanvasLayer.hide()

func _input(_event) -> void :
    if Input.is_action_just_pressed("Pausa"):
        $sfx_node.play()
        ocultar()

func ocultar():
    oculto = true
    $CanvasLayer.hide()

func mostrar():
    oculto = false
    $CanvasLayer.show()

func _on_boton_si_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    $sfx_node.play()
    get_tree().change_scene_to_file("res://assets/data/Menus/menu_principal.tscn")


func _on_boton_no_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    oculto = true
    $sfx_node.play()
    ocultar()
