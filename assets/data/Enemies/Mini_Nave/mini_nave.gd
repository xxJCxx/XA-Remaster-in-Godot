extends Node2D

@export var MovX: float = 100
@export var MovY: float = 100
@export_range(0, PI) var dirx: float
@export_range(0, PI) var diry: float
var death = false
var vida = 2
@export var vel: Vector2
@export var ModDificil = false
@onready var Sprite_Nave = $Sprite_Nave
@onready var Sprite_Daño = $"Sprite_Daño"
@onready var Sprite_Muerte = $Sprite_Muerte
@onready var Area_Daño = $"Area_Daño"
@onready var sfx_Muerte = $sfx_Muerte
@onready var sfx_Daño = $"sfx_Daño"
@onready var Animaciones = $Animaciones

func destroy():
    queue_free()

func destroy_area():
    Area_Daño.queue_free()

func hurt_true():
    Sprite_Daño.visible = true
func hurt_false():
    Sprite_Daño.visible = false
func dead():
    death = true
    Sprite_Nave.visible = false
    Sprite_Muerte.visible = true
    Sprite_Daño.visible = false
    Animaciones.play("explosion")

func _process(delta):
    print((cos(dirx) * MovX))
    if (cos(dirx) * MovX) < 0 and $Sprite_Nave.flip_h == false:
        $Sprite_Nave.flip_h = true
    elif 0 < (cos(dirx) * MovX) and $Sprite_Nave.flip_h == true:
        $Sprite_Nave.flip_h = false

    if death == true:
        dirx = 0
        diry = 0
    else:
        position.x += (cos(dirx) * MovX) * delta
        position.y += (cos(diry) * MovX) * delta
        dirx += vel.x * delta
        diry += vel.y * delta


func _on_area_2d_body_entered(body):
    if body.has_method("take_damage"):
        body.take_damage(5)
        dead()

func _on_area_2d_area_entered(area):
    if area.has_method("jump") and not death:
        area.Player.añadir_puntos(10)
        area.jump()
        dead()
    elif area.has_method("hit_enemy"):
        vida -= 1
        sfx_Daño.play()
        Animaciones.stop()
        Animaciones.play("hurt")
        if vida <= 0:
            dead()
            area.player.añadir_puntos(10)
