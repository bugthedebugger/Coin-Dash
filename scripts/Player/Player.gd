extends Area2D
signal pickup
signal hurt
signal powerup

export (int) var speed
export (bool) var debug = false
var velocity = Vector2()
var screensize = Vector2(480, 720)

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	
func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)

func _process(delta):
	if debug:
		print("Velocity: (", velocity.x, ", ", velocity.y ,")")
	get_input()
	
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	if debug:
		print("Velocity length: ", velocity.length())	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("obstacles"):
		print("Cactus!")
		emit_signal("hurt", "cactus")
	if area.is_in_group("powerup"):
		area.powerup()
		emit_signal("pickup", "powerup")
