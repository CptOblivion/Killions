extends Node2D

@export var monster: PackedScene
@export var interval_seconds: float = 1
@export var interval_variance: float = 1
@export var batch_size: int = 5
@export var distance: float = 100
@export var max_count: int = 2000

var interval_timer: float = 0


func _physics_process(delta: float) -> void:
	if MonsterBase.count >= max_count:
		return
	interval_timer -= delta
	if interval_timer > 0:
		return
	while interval_timer < 0:
		interval_timer += interval_seconds + randf_range(0, interval_variance)
		for i in range(batch_size):
			spawn()
	DebugDisplay.set_line(0, "alive: " + str(MonsterBase.count))


func spawn():
	var angle = randf_range(0, PI * 2)
	var vec = Vector2(cos(angle), sin(angle)) * distance
	var pos = Player.instance.position + vec
	MonsterBase.spawn(monster, get_parent(), pos)
