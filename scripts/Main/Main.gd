extends Node2D

export (PackedScene) var Coin
export (int) var playTime

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
	
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		spawn_coins()
	
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
	
func spawn_coins():
	for i in range(4 + level):
		var coin = Coin.instance() 
		$CoinContainer.add_child(coin)
		coin.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <= 0:
		game_over()

func _on_Player_pickup():
	score += 1
	$HUD.update_score(score)

func _on_Player_hurt():
	game_over()

func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	
	$HUD.show_game_over()
	$Player.die()
