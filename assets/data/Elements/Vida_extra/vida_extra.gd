extends Area2D

var player
var vel = 0.0
var dir = 1.0
var origin

@onready var Animacion_take_item = $Animacion_take_item
@onready var Sprite_take_item = $Sprite_take_item
@onready var Sprite_Vida_extra = $Sprite_Vida_extra
@onready var CollisionShape_Moneda = $CollisionShape

func _ready():
    player = get_tree().get_first_node_in_group("player")
    origin = position

func _physics_process(delta):
    vel = lerpf(vel, dir, 1 * delta)
    position.y += vel
    if position.y >= origin.y + 4:
        dir = -1.0
    if position.y <= origin.y:
        dir = 1.0

func desabilitar():
    CollisionShape_Moneda.disabled = true

func _on_body_entered(body: Node2D) -> void :
    if body.has_method("mod_vidas"):
        player.añadir_puntos(100)
        body.mod_vidas(1)
        Sprite_Vida_extra.visible = false
        Sprite_take_item.visible = true
        Animacion_take_item.play("take_item")
        $sfx_extra_life.play()
