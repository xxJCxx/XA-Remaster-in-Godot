extends Area2D

var vel = 0.0
var dir = 1.0
var origin
var player

@export_range(-4, 4) var init_pos = 0.0
@onready var Sprite_Moneda = $Sprite_Moneda
@onready var Sprite_take_item = $Sprite_take_item
@onready var Animacion_moneda = $Animacion_moneda
@onready var Animacion_take_item = $Animacion_take_item
@onready var CollisionShape_Moneda = $CollisionShape_Moneda

func fliph_on():
    Sprite_Moneda.flip_h = true
    Sprite_Moneda.position.x += 4
func fliph_off():
    Sprite_Moneda.position.x -= 4
    Sprite_Moneda.flip_h = false

func _ready():
    origin = position
    position.y += init_pos
    player = get_tree().get_first_node_in_group("player")
    add_to_group("monedas")
    Animacion_moneda.play("idle")

func _physics_process(delta):
    vel = lerpf(vel, dir, 1 * delta)
    position.y += vel
    if position.y >= origin.y + 4:
        dir = -1.0
    if position.y <= origin.y:
        dir = 1.0

func desabilitar():
    CollisionShape_Moneda.disabled = true

func _on_body_entered(body):
    if body.has_method("take_moneda"):
        body.take_moneda()
        player.añadir_puntos(10)
        Sprite_Moneda.visible = false
        Sprite_take_item.visible = true
        Animacion_take_item.play("take_item")
        $sfx_Coin.play()
