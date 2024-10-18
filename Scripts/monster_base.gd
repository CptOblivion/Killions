class_name MonsterBase
extends CharacterBody2D

@export var speed: int = 80
@export var max_health: int = 10

var health
var resource_path: String

enum States {DEAD, ALIVE}

var state: States = States.DEAD
var pool: Pooler

static var instance_counts = {}


func _physics_process(_delta: float) -> void:
	var vec = Player.instance.position - position
	if vec.length() < 4:
		despawn()
		return
	velocity = vec.normalized() * speed
	if velocity != Vector2.ZERO:
		move_and_slide()


func _init():
	reset()


func reset():
	health = max_health
	set_process(true)
	state = States.ALIVE


static func spawn(src: PackedScene, parent: Node, start_pos: Vector2) -> MonsterBase:
	var monster: MonsterBase = Pooler.get_pooled(src)
	if monster == null:
		monster = src.instantiate()
		monster.pool = Pooler.new(src.resource_path, monster)
	parent.call_deferred("add_child", monster)
	monster.resource_path = src.resource_path
	monster.reset()
	monster.position = start_pos
	if !instance_counts.has(monster.resource_path):
		instance_counts[monster.resource_path] = 0
	instance_counts[monster.resource_path] += 1
	return monster


func despawn():
	pool.store()
	get_parent().remove_child(self)
	instance_counts[resource_path] -= 1
