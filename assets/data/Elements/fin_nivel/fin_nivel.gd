extends Area2D

var activo = false
@export var desbloquear_nivel: int
var save_data = JSON.new()
@export_file("*.tscn") var escena

func _on_body_entered(body: Node2D) -> void :
    if body.has_method("fin_nivel"):
        save_data = ResourceLoader.load("user://save_data.json")
        save_data.data.niveles[desbloquear_nivel - 1].desbloqueado = true
        save_data.data.nivel_actual = desbloquear_nivel
        ResourceSaver.save(save_data, "user://save_data.json")
        activo = true
        $Timer.start()
        $Music_node.play()
        body.fin_nivel()


func _on_timer_timeout() -> void :
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    get_tree().change_scene_to_file(escena)
