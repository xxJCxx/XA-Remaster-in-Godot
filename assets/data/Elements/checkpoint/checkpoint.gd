extends Area2D

@export var id = 1

func _physics_process(delta: float) -> void :
    if is_in_group("checkpoint_on"):
        if not $Animacion.current_animation == "guardado":
            $Animacion.play("guardado")
    else:
        if not $Animacion.current_animation == "idle":
            $Animacion.play("idle")
func _on_body_entered(body: Node2D) -> void :
    if body.has_method("mod_checkpoint"):
        if not body.checkpoint_id == id:
            if get_tree().get_first_node_in_group("checkpoint_on"):
                get_tree().get_first_node_in_group("checkpoint_on").remove_from_group("checkpoint_on")
            add_to_group("checkpoint_on")
            body.checkpoint_id = id
            body.mod_checkpoint(global_position)
            $sfx_save.play()
