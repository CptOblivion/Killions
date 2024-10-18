class_name MonsterBase
extends CharacterBody2D

@export var speed: int = 80
@export var max_health: int = 10
@export var density_push_factor: float = 1.0

var health
var resource_path: String

enum States {DEAD, ALIVE}

var state: States = States.DEAD
var pool: Pooler

static var instance_counts = {}

var grid_node: GridNode
var grid_next: MonsterBase
var grid_prev: MonsterBase


func _physics_process(_delta: float) -> void:
	var vec = Player.instance.position - position
	if vec.length() < 4:
		despawn()
		return
	velocity = vec.normalized() * speed
	velocity += calc_density_push()
	if velocity != Vector2.ZERO:
		move_and_slide()
		update_grid_position()


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
	if !instance_counts.has(monster.resource_path):
		instance_counts[monster.resource_path] = 0
	instance_counts[monster.resource_path] += 1
	monster.reset()
	monster.set_position(start_pos)
	monster.update_grid_position()
	return monster


func despawn():
	pool.store()
	var parent = get_parent()
	if parent != null:
		parent.remove_child(self)
	instance_counts[resource_path] -= 1

func update_grid_position():
	var grid_pos = LevelController.get_grid_position(position)
	if grid_node != null && grid_pos == grid_node.position: # TODO: verify that vector comparison is comparing values rather than pointers
		return
	var new_node = LevelController.get_grid_node_ind(grid_pos)
	if new_node == null:
		#TODO: maybe we should have some fallback behavior instead of just a kill
		push_warning("monster got out of bounds at " + str(grid_pos))
		despawn()
		return
	if new_node == grid_node: # TODO: verify we're comparing pointers, no need to compare values
		return

	if grid_node == null:
		add_to_grid_node(new_node)
		return

	remove_from_node()
	add_to_grid_node(new_node)


func add_to_grid_node(node: GridNode):
	grid_prev = null
	grid_next = node.monsters_head
	if node.monsters_head != null:
		node.monsters_head.grid_prev = self
	node.monsters_head = self
	node.monster_count += 1
	grid_node = node

func remove_from_node():
	if grid_node.monsters_head == self:
		grid_node.monsters_head = grid_next
	if grid_next != null:
		grid_next.grid_prev = grid_prev
	if grid_prev != null:
		grid_prev.grid_next = grid_next
	grid_next = null
	grid_prev = null
	grid_node.monster_count -= 1


func calc_density_push() -> Vector2:
	var force = Vector2.ZERO
	var grid_pos = LevelController.get_grid_position(position)
	# var current_density = grid_node.monster_count - 1 # can't forget to discount self from current cell density
	# for x in range(-1, 1):
	# 	for y in range(-1, 1):
	# 		if x == 0 && y == 0:
	# 			continue
	# 		var cell = LevelController.get_grid_node_ind(grid_pos + Vector2i(x, y))
	# 		if cell == null:
	# 			continue
	# 			# TODO: we should probably treat this case as high density, or maybe equal to the highest found (otherwise we bias towards leaving the level when right next to border)
	# 			# though in the future the level border should be impassible, which means obstacle avoidance should take over
	# 		var magnitude = cell.monster_count - current_density
	# 		force += Vector2(x, y).normalized() * magnitude
	# 		#TODO: we should actually go beyond normalizing (divide by magnitude twice?)—diagonal cells should have less influence than cardinal

	#TODO: revisit this push factor here
	for x in range(-1, 1):
		for y in range(-1, 1):
			var cell = LevelController.get_grid_node_ind(grid_pos + Vector2i(x, y))
			if cell == null:
				continue
			var neighbor = grid_node.monsters_head
			var escape = 1000
			while neighbor != null:
				escape -= 1
				if neighbor == self:
					neighbor = neighbor.grid_next
					continue
				var vec = position - neighbor.position
				var dist = vec.length()
				vec = vec.normalized() / dist
				neighbor = neighbor.grid_next
				assert(escape > 0)
				force += vec

	return force * density_push_factor
