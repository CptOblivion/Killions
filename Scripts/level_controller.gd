class_name LevelController
extends Node2D

@export var grid_dimensions: Vector2i = Vector2i(500, 500)
@export var grid_scale: int = 16

static var grid_scale_static: int
static var grid_dimensions_static: Vector2i
static var grid_center: Vector2 = Vector2.ZERO

static var path_grid: Array[Array] # TODO: figure out if we can do better type hints—should be Array[Array[GridNode]]

func _ready() -> void:
	fill_grid()
	grid_scale_static = grid_scale
	grid_dimensions_static = grid_dimensions
	grid_center = grid_dimensions / 2

func fill_grid():
	# TODO: should we store Y first instead?
	path_grid = []
	path_grid.resize(grid_dimensions.x)
	for x in range(grid_dimensions.x):
		path_grid[x] = []
		path_grid[x].resize(grid_dimensions.y)
		for y in range(grid_dimensions.y):
			path_grid[x][y] = GridNode.new(Vector2i(x, y))

func _process(_delta: float) -> void:
	# on some schedule (a couple times a second?) update pathing and density
	pass

static func get_grid_position(pos: Vector2) -> Vector2i:
	var scaled_pos = pos / grid_scale_static
	return scaled_pos + grid_center


# get the grid node at given world location, or null if location out of bounds
static func get_grid_node_world(pos: Vector2) -> GridNode:
	pos = get_grid_position(pos)
	return get_grid_node_ind(pos)


# get the grid node at given indices, or null if indices out of bounds
static func get_grid_node_ind(pos: Vector2i) -> GridNode:
	if pos.x < 0 || pos.y < 0 || pos.x >= path_grid.size() || pos.y >= path_grid[0].size():
		return null
	return path_grid[pos.x][pos.y]
