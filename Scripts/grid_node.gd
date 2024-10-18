class_name GridNode

# tightly coupled with LevelController and MonsterBase

var monsters_head: MonsterBase

var monster_count: int = 0
var monster_density: float = 0 # probably will be redundant with count but monster size could be a factor

var position: Vector2i


func _init(pos: Vector2i) -> void:
	position = pos
	pass