extends Camera2D

var randomstreght: float = 30.0
var shackefade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_streght: float = 0.0

# Called when the node enters the scene tree for the first time.
func applyshake():
	shake_streght = randomstreght


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_streght > 0:
		shake_streght = lerpf(shake_streght, 0, shackefade * delta)
		
		offset = randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_streght,shake_streght), rng.randf_range(-shake_streght,shake_streght))
