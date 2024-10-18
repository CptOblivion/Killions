class_name LevelController
extends Node2D

@export var level_width: int = 500
@export var level_height = 500
@export var grid_scale: int = 16

static var grid_scale_static: int

static var path_grid: Array[Array] # TODO: figure out if we can do better type hints—should be Array[Array[GridNode]]

func _ready() -> void:
  fill_grid()
  grid_scale_static = grid_scale

func fill_grid():
  # TODO: should we store Y first instead?
  path_grid = []
  path_grid.resize(level_width)
  for x in range(level_width):
    path_grid[x] = []
    path_grid[x].resize(level_height)
    for y in range(level_height):
      path_grid[x][y] = GridNode.new(Vector2i(x, y))

func _process(delta: float) -> void:
  # on some schedule (a couple times a second?) update pathing and density
  pass

static func get_grid_node(pos: Vector2i) -> GridNode:
  if pos.x < 0 || pos.y < 0 || pos.x >= path_grid.size() || pos.y >= path_grid[0].size():
    return null
  return path_grid[pos.x][pos.y]