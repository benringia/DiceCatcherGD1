extends Area2D

class_name Fox

signal score_point

@export var speed: float = 320.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var sound: AudioStreamPlayer2D = $Sound

func _physics_process(delta: float) -> void:
	#Set move left or right (A or D)
	var move: float = Input.get_axis("ui_left", "ui_right")
	
	#if Input.is_action_pressed("ui_left"):
	#	move -= speed
	#if Input.is_action_pressed("ui_right"):
	#	move += speed
	
	if !is_zero_approx(move) :
		sprite_2d.flip_h = move > 0.0
		
	position.x += move * delta * speed


func _on_area_entered(area: Area2D) -> void:
	if area is Dice: 
		sound.play()
		area.queue_free()
		score_point.emit()
