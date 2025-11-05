extends Control

var activo = false
var config = ConfigFile.new()

func _ready() -> void :
    $CanvasLayer.show()
    activo = false
    hide()
    $CanvasLayer.hide()

func ocultar():
    activo = false
    hide()
    $CanvasLayer.hide()

func mostrar():
    activo = true
    show()
    $CanvasLayer.show()

func _on_boton_si_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    $sfx_node.play()
    get_tree().quit()


func _on_boton_no_pressed() -> void :
    Input.vibrate_handheld(30, 0.5)
    activo = false
    $sfx_node.play()
    hide()
    $CanvasLayer.hide()
