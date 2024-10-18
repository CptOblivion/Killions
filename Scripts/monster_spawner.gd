extends Node2D

@export var monster: PackedScene
@export var interval_seconds: float = 1
@export var interval_variance: float = 0
@export var batch_size: int = 1
@export var distance: float = 750 # screen diagonal half is 734.3 for a 720p screen
@export var max_count: int = 1000

var interval_timer: float = 0


func _process(delta: float):
	# TODO: how should spawn behavior be when monster count has been at limit for a while? run timer to exactly 0 so they start fresh? pause timer while at limit?
	if MonsterBase.instance_counts.has(monster.resource_path) && MonsterBase.instance_counts[monster.resource_path] >= max_count:
		return
	interval_timer -= delta
	while interval_timer < 0:
		interval_timer += interval_seconds + randf_range(0, interval_variance)
		for i in range(batch_size):
			spawn()
			if MonsterBase.instance_counts[monster.resource_path] >= max_count:
				interval_timer = 0


func spawn():
	var angle = randf_range(0, PI * 2)
	var vec = Vector2(cos(angle), sin(angle)) * distance
	var pos = Player.instance.position + vec
	MonsterBase.spawn(monster, self, pos)
