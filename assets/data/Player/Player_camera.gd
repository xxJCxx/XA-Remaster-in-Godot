extends Camera2D

var randomstreght: float = 30.0
var shackefade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_streght: float = 0.0


func applyshake():
    shake_streght = randomstreght


func _process(delta):
    if not $"..".velocity.x == 0:
        position.x = lerpf(position.x, 100 * $"..".direction, 0.1)
    if shake_streght > 0:
        shake_streght = lerpf(shake_streght, 0, shackefade * delta)

        offset = randomOffset()

func randomOffset() -> Vector2:
    return Vector2(rng.randf_range( - shake_streght, shake_streght), rng.randf_range( - shake_streght, shake_streght))
