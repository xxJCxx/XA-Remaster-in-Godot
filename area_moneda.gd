extends Area2D

var player

func fliph_on():
	$"../Sprite2D".flip_h = true
	$"../Sprite2D".position.x += 4
func fliph_off():
	$"../Sprite2D".position.x -= 4
	$"../Sprite2D".flip_h = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("monedas")
	$"../AnimationPlayer2".play("idle")

func desabilitar():
	$CollisionShape2D.disabled = true

func _on_body_entered(body):
	if body.has_method("take_moneda"):
		body.take_moneda()
		player.añadir_puntos(10)
		$"../Sprite2D".visible = false
		$"../Sprite2D2".visible = true
		$"../AnimationPlayer".play("take_item")
		$"../AudioStreamPlayer2D".play()
