extends Node2D


const DICE = preload("uid://cby2mqaa86h7s")
const MARGIN : float = 80.0
const STOPPABLE_GROUP : String = "stoppable"
const GAME_OVER = preload("uid://svpflsu5jowm")

@onready var spawn_timer: Timer = $Pausable/SpawnTimer
@onready var music: AudioStreamPlayer = $Music

var _points: int = 0
@onready var score_label: Label = $ScoreLabel
@onready var pausable: Node = $Pausable

#Set ESC key to RELOAD game
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score_label()
	spawn_dice()
	get_tree().paused = false


func spawn_dice() -> void:
	var new_dice: Dice = DICE.instantiate()
	var viewport_rect: Rect2 = get_viewport_rect()
	var new_x: float = randf_range(
		viewport_rect.position.x + MARGIN,
		viewport_rect.end.x - MARGIN
	)
	new_dice.position = Vector2(new_x, -MARGIN)
	
	#CONNECT OT SIGNAL
	new_dice.game_over.connect(_on_dice_game_over)
	
	pausable.add_child(new_dice)

func pause_all() -> void:
	spawn_timer.stop()
	var to_stop: Array[Node] = get_tree().get_nodes_in_group(STOPPABLE_GROUP)
	for item in to_stop:
		item.set_physics_process(false)
		
		
func update_score_label() -> void:
	score_label.text = "%04d" % _points

#Game over signal
func _on_dice_game_over() -> void:
	#pause_all()
	music.stop()
	music.stream = GAME_OVER
	music.play()
	get_tree().paused = true

#Timer Scene
func _on_spawn_timer_timeout() -> void:
	spawn_dice()

#Fox score
func _on_fox_score_point() -> void:
	_points += 1
	update_score_label()
	
