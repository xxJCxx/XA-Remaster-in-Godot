extends CharacterBody2D

var player
var bullet
var vida = 5
var death = false
var dir = -1
@export var mov = true
@export var caida = true
const SPEED = 73.0
const JUMP_VELOCITY = -210.0

var bala = preload("res://assets/data/Bullets/Bala_Roja/bala_roja.tscn")
@onready var raycast = $RayCast
@onready var sfx_Daño = $"sfx_Daño"
@onready var Sprite_Robot_resorte = $Sprite_Robot_resorte
@onready var Area_Daño = $"Colision_Robot_resorte/Area_daño"
@onready var Area_Daño2 = $"Colision_Robot_resorte/Area_daño2"
@onready var Tiempo_salto = $Tiempo_salto
@onready var Animaciones = $Animaciones
@onready var Animaciones_daño = $Animaciones_daño
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func hurt_true():
    Sprite_Robot_resorte.texture = load("res://assets/images/enemies/plantilla_enemigos_xa_red.png")
func hurt_false():
    Sprite_Robot_resorte.texture = load("res://assets/images/enemies/plantilla_enemigos_xa.png")

func destroy():
    queue_free()

func destroy_collision():
    Area_Daño.queue_free()
    Area_Daño2.queue_free()

func explosion():
    bullet = bala.instantiate()
    get_parent().add_child(bullet)
    bullet.dirx = 1
    bullet.diry = 0
    bullet.global_position = global_position

    if not raycast.is_colliding():
        bullet = bala.instantiate()
        get_parent().add_child(bullet)
        bullet.dirx = 1
        bullet.diry = 1
        bullet.global_position = global_position
        bullet.vel = 3

        bullet = bala.instantiate()
        get_parent().add_child(bullet)
        bullet.dirx = 0
        bullet.diry = 1
        bullet.global_position = global_position

        bullet = bala.instantiate()
        get_parent().add_child(bullet)
        bullet.dirx = -1
        bullet.diry = 1
        bullet.global_position = global_position
        bullet.vel = 3

    bullet = bala.instantiate()
    get_parent().add_child(bullet)
    bullet.dirx = -1
    bullet.diry = 0
    bullet.global_position = global_position

    bullet = bala.instantiate()
    get_parent().add_child(bullet)
    bullet.dirx = -1
    bullet.diry = -1
    bullet.global_position = global_position
    bullet.vel = 3


    bullet = bala.instantiate()
    get_parent().add_child(bullet)
    bullet.dirx = 0
    bullet.diry = -1
    bullet.global_position = global_position

    bullet = bala.instantiate()
    get_parent().add_child(bullet)
    bullet.dirx = 1
    bullet.diry = -1
    bullet.global_position = global_position
    bullet.vel = 3

func dead():
    death = true
    Sprite_Robot_resorte.visible = false
    Animaciones_daño.play("explosion")
    destroy_collision()
    mov = false

func jump():
    velocity.y = JUMP_VELOCITY

func _ready():
    player = get_tree().get_first_node_in_group("player")
    $Sprite_Muerte.visible = false
    Tiempo_salto.start()

func _physics_process(delta):
    if death == false:
        if is_on_wall():
            dir = - dir
        if Tiempo_salto.time_left == 0 and is_on_floor():
            Animaciones.play("Salto")
        elif is_on_floor() and caida == true:
            Animaciones.play("Caida")
        if not is_on_floor():
            if mov == true and (global_position.x - player.global_position.x) < 960:
                velocity.x = SPEED * dir
            caida = true
            velocity.y += gravity / 3 * delta
        else:
            velocity.x = 0
        velocity.y = clamp(velocity.y, -250, 250)
        move_and_slide()


func _on_area_daño_area_entered(area: Area2D) -> void :
    if area.has_method("jump"):
        area.Player.añadir_puntos(15)
        area.jump()
        dead()
    elif area.has_method("hit_enemy"):
        vida -= 1
        sfx_Daño.play()
        Animaciones_daño.play("hurt")
        if vida <= 0:
            area.player.añadir_puntos(15)
            explosion()
            dead()


func _on_area_daño_2_body_entered(body: Node2D) -> void :
    if body.has_method("take_damage"):
        body.take_damage(5)
        dead()
