extends Area2D

var player

func _ready() -> void :
    player = get_tree().get_first_node_in_group("player")
    $Sprite_vaca.visible = false
    add_to_group("vacas")

func desabilitar_colision():
    $CollisionShape.queue_free()

func _on_body_entered(body: Node2D) -> void :
    if body.has_method("actualizar_vacas_rescatadas"):
        body.actualizar_vacas_rescatadas()
        $Sprite_vaca.visible = true
        $Sprite_encerrada.visible = false
        $sfx_gracias.play()
        $Animaciones.play("take_vaca")
        desabilitar_colision()
        player.añadir_puntos(1000)
