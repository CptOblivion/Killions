class_name Pooler

var _next: Pooler
var parent: Object
var pool: PoolContainer

static var pools = {}


func _init(path: String, _parent: Object):
	if !pools.has(path):
		pools[path] = PoolContainer.new()
	pool = pools[path]
	parent = _parent


static func get_pooled(scene: PackedScene) -> Object:
	var src_path = scene.resource_path
	if !pools.has(src_path):
		return null
	var tar_pool: PoolContainer = pools[src_path]
	if tar_pool.head == null:
		return null
	tar_pool.pool_count -= 1
	var instance = tar_pool.head
	tar_pool.head = instance._next
	instance._next = null
	return instance.parent


func store():
	#TODO: some sort of path check to ensure we're not mixing different resources in one pool?
	_next = pool.head
	pool.head = self
	pool.pool_count += 1


func get_next() -> Object:
	if _next == null:
		return null
	return _next.parent


class PoolContainer:
	var path: String
	var pool_count: int = 0
	var head: Pooler
