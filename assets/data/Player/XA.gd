extends CharacterBody2D

var fin = false

var save_data = JSON.new()
var config_file = ConfigFile.new()
var checkpoint_id = -1
var checkpoint
var cont_tiempo = "00 : 00"
var tiempo = Vector2(0, 0)

@export var death = false
var contador_puntos = 0
var balas = 3
var monedas = 0
var vacas_rescatadas = 0
var vacas_restantes = 0
var porcentaje_monedas = 0
var direction
var mov = true
var puntos = 0
var doble_salto_activado = true
var doble_salto = false
var vidas = 3
var vida = 11
var dir = 1
var bullet
var disparo_en_el_aire = false

const SPEED = 250.0
const JUMP_VELOCITY = -600.0

@export var inicio = true
@onready var bala = preload("res://assets/data/Bullets/Bala_Verde/bala_verde.tscn")
@onready var efecto = preload("res://assets/data/Elements/Doble_Salto/efecto_salto_doble.tscn")
@onready var Camera: Camera2D = $Camera2D
@onready var animationTree: AnimationTree = $AnimationTree
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func fin_nivel():
	$sfx_pasos.volume_db = -80
	fin = true
	$"..".guardar_datos()
	animationTree.set("parameters/conditions/caminando", true)

func mod_checkpoint(pos):
	checkpoint = pos
	$Camera2D / HUD / CanvasLayer / Sprite_Guardado.visible = true
	$Camera2D / HUD / CanvasLayer / Animation_Guardado.play("Guardado")

func reespawn():
	vida = 11
	mod_vidas(-1)
	global_position = checkpoint
	$Camera2D / HUD / CanvasLayer / Animacion_Color_rect.play("ocultar")

func dead():
	desactivar_animaciones()
	animationTree.set("parameters/conditions/idle", true)
	$Camera2D / HUD / CanvasLayer / Animacion_Color_rect.play("mostrar")
	velocity.x = 0
	velocity.y = 0
	death = true
	$Animacion_reaparicion_muerte.play("muerte")

func actualizar_vacas_rescatadas():
	vacas_rescatadas += 1
	if vacas_rescatadas >= 10:
		$Camera2D / HUD / CanvasLayer / vacas / label_vacas_rescatadas.text = vacas_rescatadas
	else:
		$Camera2D / HUD / CanvasLayer / vacas / label_vacas_rescatadas.text = "0" + str(vacas_rescatadas)

func actualizar_vacas_restantes(vacas):
	vacas_restantes = vacas
	if vacas_restantes >= 10:
		$Camera2D / HUD / CanvasLayer / vacas / label_vacas_restantes.text = vacas_restantes
	else:
		$Camera2D / HUD / CanvasLayer / vacas / label_vacas_restantes.text = "0" + str(vacas_restantes)

func take_moneda():
	monedas += 1

func take_leche():
	vida += 4
	vida = clamp(vida, 0, 11)

func mov_on():
	mov = true
func mov_off():
	mov = false

func desactivar_animaciones():
	animationTree.set("parameters/conditions/Activar_escudo", false)
	animationTree.set("parameters/conditions/caminando", false)
	animationTree.set("parameters/conditions/Disparando", false)
	animationTree.set("parameters/conditions/Disparar_agachado", false)
	animationTree.set("parameters/conditions/Disparar_caminando", false)
	animationTree.set("parameters/conditions/Disparar_en_el_aire", false)
	animationTree.set("parameters/conditions/idle", false)
	animationTree.set("parameters/conditions/Salto", false)

func actualizar_vida():
	if vida == 11:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 9
	elif vida == 10:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 8
	elif vida == 9:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 7
	elif vida == 8:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 6
	elif vida <= 7 and vida >= 6:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 5
	elif vida == 5:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 4
	elif vida == 4:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 3
	elif vida == 3:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 2
	elif vida <= 2:
		$Camera2D / HUD / CanvasLayer / barra_vida.frame = 1

func disparo():
	if $Timer3.time_left == 0:
		bullet = bala.instantiate()
		bullet.vel = bullet.vel * dir
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.global_position.x += 16 * dir
		bullet.player = $"."
		if animationTree.get("parameters/conditions/Disparar_agachado") == true:
			bullet.global_position.y += 2
		$sfx_bala.play()

func rafaga_balas():
	if $Timer4.time_left == 0 and balas > 0 and $Timer3.time_left == 0:
		$Timer4.start()
		disparo()
		balas -= 1
	elif balas == 0:
		balas = 3
		$Timer3.start()

func daño_shader_on():
	set("modulate", Color(100, 0, 0))
func daño_shader_off():
	set("modulate", Color(1, 1, 1))

func take_damage(daño):
	Input.vibrate_handheld(300, 0.75)
	$AnimationPlayer2.play("daño")
	vida -= daño
	vida = clamp(vida, 0, 11)
	$"sfx_daño".play()
	$Camera2D.applyshake()

func jump():
	velocity.y = JUMP_VELOCITY

func doble_jump():
	if doble_salto == true and doble_salto_activado == true and $CoyoteTime.time_left == 0:
		velocity.y = JUMP_VELOCITY
		$sfx_doble_salto.play()
		doble_salto_activado = false
		var efecto_doble_salto = efecto.instantiate()
		get_parent().add_child(efecto_doble_salto)
		efecto_doble_salto.global_position = global_position

func take_doble_salto():
	doble_salto = true
	$Camera2D / HUD / CanvasLayer / doble_salto.hide()
	$Camera2D / HUD / CanvasLayer / doble_salto_anim.show()
	$AnimationPlayer3.play("doble_salto_anim")

func añadir_puntos(nuevos_puntos):
	puntos += int(nuevos_puntos)
	if puntos >= 999999:
		puntos = 999999

func mod_vidas(mod):

	vidas += int(mod)
	save_data = ResourceLoader.load("user://save_data.json")
	save_data.data.vidas = vidas
	ResourceSaver.save(save_data, "user://save_data.json")
	vidas = int(save_data.data.vidas)

	if vidas >= 99:
		vidas = 99
	if vidas > 9:
		$Camera2D / HUD / CanvasLayer / vidas / Label.text = str(vidas)
	else:
		$Camera2D / HUD / CanvasLayer / vidas / Label.text = "0" + str(vidas)

func _ready():

	$Camera2D / HUD / CanvasLayer / ColorRect.visible = true
	$Camera2D / HUD / CanvasLayer / Animacion_Color_rect.play("ocultar")
	$SpriteHero_reaparicion_muerte.visible = false
	checkpoint = global_position
	DisplayServer.window_set_position(Vector2(80, 80))

	$Camera2D / HUD / CanvasLayer / puntos / Label.text = str(puntos)
	if vidas > 9:
		$Camera2D / HUD / CanvasLayer / vidas / Label.text = str(vidas)
	else:
		$Camera2D / HUD / CanvasLayer / vidas / Label.text = "0" + str(vidas)

func _physics_process(delta):

	if fin == true:
		animationTree.set("parameters/conditions/caminando", true)
		if not $Camera2D / HUD / CanvasLayer / Animacion_Color_rect.is_playing() and $Camera2D / HUD / CanvasLayer / Animacion_Color_rect / Timer.time_left == 0:
			$Camera2D / HUD / CanvasLayer / Animacion_Color_rect / Timer.start()

	if 10 > porcentaje_monedas:
		$Camera2D / HUD / CanvasLayer / monedas / Label.text = "00" + str(porcentaje_monedas)
	elif 100 > porcentaje_monedas and porcentaje_monedas >= 10:
		$Camera2D / HUD / CanvasLayer / monedas / Label.text = "0" + str(porcentaje_monedas)
	elif porcentaje_monedas >= 100:
		$Camera2D / HUD / CanvasLayer / monedas / Label.text = str(porcentaje_monedas)



	if tiempo.x >= 10 and tiempo.y >= 10:
		cont_tiempo = str(tiempo.x, " : ", int(tiempo.y))
	elif 10 >= tiempo.x and 10 >= tiempo.y:
		cont_tiempo = str("0", tiempo.x, " : ", "0", int(tiempo.y))
	elif tiempo.x >= 10 and 10 >= tiempo.y:
		cont_tiempo = str(tiempo.x, " : ", "0", int(tiempo.y))
	elif tiempo.y >= 10 and 10 >= tiempo.x:
		cont_tiempo = str("0", tiempo.x, " : ", int(tiempo.y))

	$Camera2D / HUD / CanvasLayer / Label3.text = str(cont_tiempo)
	tiempo.y += 1 * delta

	if tiempo.y >= 60:
		tiempo.y = 0
		tiempo.x += 1

	tiempo = clamp(tiempo, Vector2(0, 0), Vector2(99, 60))

	contador_puntos = int(lerp(float(contador_puntos), float(puntos), 0.5))
	if contador_puntos == puntos - 1:
		contador_puntos = puntos
	$Camera2D / HUD / CanvasLayer / puntos / Label.text = str(contador_puntos)

	if death == false and inicio == true and is_on_floor() and not $Animacion_reaparicion_muerte.current_animation == "intro":
		desactivar_animaciones()
		animationTree.set("parameters/conditions/idle", true)
		$Animacion_reaparicion_muerte.play("intro")
		velocity.x = 0

	if fin == false and inicio == false:

		if not Input.is_action_pressed("Disparo"):
			balas = 3
			$Timer3.stop()
			$Timer4.stop()

		if mov == true:
			direction = Input.get_axis("Izquierda", "Derecha")
		else:
			direction = 0

		if velocity.x == 0 and Input.is_action_pressed("Abajo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Activar_escudo", true)
		else:
			animationTree.set("parameters/conditions/Activar_escudo", false)

		if Input.is_action_pressed("Disparo") and is_on_floor() and velocity.x == 0 and velocity.y == 0 and not Input.is_action_pressed("Abajo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Disparando", true)
		elif Input.is_action_pressed("Disparo") and Input.is_action_pressed("Abajo") and velocity.y == 0:
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Disparar_agachado", true)
		elif is_on_floor() and direction and not velocity.x == 0 and Input.is_action_pressed("Disparo"):
			animationTree.set("parameters/conditions/Disparando", false)
			animationTree.set("parameters/conditions/Disparar_caminando", true)
		else:
			animationTree.set("parameters/conditions/Disparando", false)

		if Input.is_action_pressed("Disparo"):
			rafaga_balas()

		if direction and is_on_floor() and not Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/caminando", true)
		elif direction and is_on_floor() and Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Disparar_caminando", true)

		if direction and not Input.is_action_pressed("Abajo"):
			velocity.x = direction * SPEED
			dir = int(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_floor() and velocity.x == 0 and velocity.y == 0 and animationTree.get("parameters/conditions/Disparando") == false and not Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/idle", true)
		else:
			animationTree.set("parameters/conditions/idle", false)


		if direction == -1 and not Input.is_action_pressed("Abajo"):
			$SpriteHero.flip_h = true
			$SpriteHero_reaparicion_muerte.flip_h = true
			$CollisionShape2D.position.x = -2.5
			$Area2D / CollisionShape2D.position.x = -2.5
		elif direction == 1 and not Input.is_action_pressed("Abajo"):
			$SpriteHero.flip_h = false
			$SpriteHero_reaparicion_muerte.flip_h = false
			$CollisionShape2D.position.x = 2.5
			$Area2D / CollisionShape2D.position.x = 2.5
		elif not Input.is_action_pressed("Abajo"):
			$StaticBody2D / CollisionShape2D2.disabled = true
			$StaticBody2D / CollisionShape2D.disabled = true
		if Input.is_action_pressed("Abajo") and $SpriteHero.flip_h == true:
			$StaticBody2D / CollisionShape2D.disabled = true
			$StaticBody2D / CollisionShape2D2.disabled = false
		elif Input.is_action_pressed("Abajo") and $SpriteHero.flip_h == false:
			$StaticBody2D / CollisionShape2D.disabled = false
			$StaticBody2D / CollisionShape2D2.disabled = true

		if is_on_floor():
			$CoyoteTime.start()
			doble_salto_activado = true
		elif Input.is_action_just_pressed("Salto"):
			doble_jump()

		if Input.is_action_pressed("Salto") and not $CoyoteTime.time_left == 0 and not animationTree.get("parameters/conditions/Activar_escudo") == true:
			if mov == true:
				$CoyoteTime.stop()
				$sfx_salto.play()
				jump()

	$Camera2D / HUD / CanvasLayer / barra_vida2.scale.x = lerpf($Camera2D / HUD / CanvasLayer / barra_vida2.scale.x, vida / 8.5, 0.02)
	while $Camera2D / HUD / CanvasLayer / puntos / Label.get_total_character_count() < 6:
		$Camera2D / HUD / CanvasLayer / puntos / Label.text = "0" + $Camera2D / HUD / CanvasLayer / puntos / Label.text


	if not is_on_floor():
		desactivar_animaciones()
		if fin == false:
			animationTree.set("parameters/conditions/Salto", true)
		if death == false:
			velocity.y += gravity * 2 * delta
		if Input.is_action_pressed("Disparo") and fin == false:
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Disparar_en_el_aire", true)
			disparo_en_el_aire = true
	velocity.y = clampf(velocity.y, -600.0, 600.0)
	if 0 >= vida and death == false:
		dead()
	actualizar_vida()
	move_and_slide()
