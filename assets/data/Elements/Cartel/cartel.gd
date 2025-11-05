extends Area2D

@export_multiline var texto: String

func _ready() -> void :
    $Animaciones.play("hide")
    $Pivote / PanelContainer / texto.text = texto

func _on_body_entered(body: Node2D) -> void :
    $Animaciones.play("show")


func _on_body_exited(body: Node2D) -> void :
    $Animaciones.play("hide")
