extends Area2D

var player
var dir = 0.4
var vel = 0.4
var origin

func _ready():
    player = get_tree().get_first_node_in_group("player")
    origin = $"..".position


func _process(delta):
    vel = lerpf(vel, dir, 1 * delta)
    $"..".position.y += vel
    if $"..".position.y >= origin.y + 5:
        dir = -0.4
    if $"..".position.y <= origin.y:
        dir = 0.4

func desabilitar():
    $CollisionShape2D.disabled = true

func _on_body_entered(body):

    if body.has_method("take_doble_salto"):
        player.añadir_puntos(100)
        body.take_doble_salto()
        $"../Sprite2D".visible = false
        $"../Sprite2D2".visible = true
        $"../AnimationPlayer".play("take_item")
        $"../AudioStreamPlayer2D".play()
