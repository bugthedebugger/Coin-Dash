extends Area2D

func _ready():
	$Tween.interpolate_property(
		$AnimatedSprite,
		"scale",
		$AnimatedSprite.scale,
		$AnimatedSprite.scale * 3,
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	$Tween.interpolate_property(
		$AnimatedSprite,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	
	$BounceTweenDown.interpolate_property(
		$AnimatedSprite,
		"position",
		$AnimatedSprite.position,
		$AnimatedSprite.position + Vector2(0, 30),
		0.8,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	
	$BounceTweenUp.interpolate_property(
		$AnimatedSprite,
		"position",
		$AnimatedSprite.position + Vector2(0, 30),
		$AnimatedSprite.position,
		0.8,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	
	$Timer.wait_time = rand_range(1, 2)
	$Timer.start()
	
	bounceDown()
	
func bounceDown():
	$BounceTweenDown.reset_all()
	$BounceTweenDown.start()
	
func bounceUp():
	$BounceTweenUp.reset_all()
	$BounceTweenUp.start()

func pickup():
	monitoring = false
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free()


func _on_BounceTweenDown_tween_completed(object, key):
	bounceUp()


func _on_BounceTweenUp_tween_completed(object, key):
	bounceDown()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("shine")
