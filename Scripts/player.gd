class_name Player
extends CharacterBody2D

static var instance: Player

const ACTION_MOVE_UP = "move_up"
const ACTION_MOVE_DOWN = "move_down"
const ACTION_MOVE_LEFT = "move_left"
const ACTION_MOVE_RIGHT = "move_right"

@export var speed = 100


func _ready() -> void:
	instance = self


func _physics_process(_delta: float) -> void:
	_get_input()
	move_and_slide()


func _get_input():
	var input_dir = Input.get_vector(ACTION_MOVE_LEFT, ACTION_MOVE_RIGHT, ACTION_MOVE_UP, ACTION_MOVE_DOWN)
	velocity = input_dir * speed
