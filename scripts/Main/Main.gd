extends Node2D

export (PackedScene) var Coin
export (PackedScene) var PowerUp
export (PackedScene) var Cactus
export (int) var playTime
export (bool) var debug = false
export (int) var minPowerUpTime = 3
export (int) var maxPowerUpTime = 10

var level
var score
var time_left
var screensize
var playing = false


func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
# warning-ignore:unused_argument
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		spawn_coins()
		clean_obstacles()
		spawn_obstacles()
		
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playTime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$HUD.update_score(score)
	$HUD.update_time(time_left)
	spawn_coins()
	clean_obstacles()
	spawn_obstacles()
	
func spawn_coins():
	$LevelSound.play()
	$PowerUpTimer.wait_time = rand_range(minPowerUpTime, maxPowerUpTime)
	$PowerUpTimer.start()
# warning-ignore:unused_variable
	for i in range(4 + level):
		var coin = Coin.instance() 
		coin.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
		$CoinContainer.add_child(coin)
		
func spawn_obstacles():
	for i in range(3 + level):
		var cactus = Cactus.instance()
		cactus.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
		$CactusContainer.add_child(cactus)
		
func clean_obstacles():
	for cactus in $CactusContainer.get_children():
		cactus.queue_free()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			if debug:
				print("Coin picked up")
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			if debug:
				print("Powerup picked up")
			time_left += 5
			$PowerUpSound.play()
			$HUD.update_time(time_left)
		"cactus":
			if debug:
				print("Hit cactus")

func _on_Player_hurt(type):
	game_over()

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	for powerUp in $PowerUpContainer.get_children():
		powerUp.queue_free()
		
	$PowerUpTimer.stop()
	$HUD.show_game_over()
	$Player.die()

func _on_PowerUpTimer_timeout():
	var powerUp = PowerUp.instance()
	powerUp.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
	$PowerUpContainer.add_child(powerUp)
