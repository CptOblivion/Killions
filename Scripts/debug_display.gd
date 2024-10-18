class_name DebugDisplay
extends RichTextLabel

static var instance: DebugDisplay
static var lines = PackedStringArray()
static var changed = false


static func set_line(line: int, val: String):
	if lines.size() < line + 1:
		lines.resize(line + 1)
	lines[line] = val


func _ready() -> void:
	instance = self


func _process(_delta: float):
	text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"
	text += "\n".join(lines)
	text += "\n" + print_monsters()


func print_monsters() -> String:
	var out = "monsters\n"
	var monsters = PackedStringArray(MonsterBase.instance_counts.keys())
	monsters.sort()
	for i in range(monsters.size()):
		var monster = monsters[i]
		monsters[i] = monster + ": " + str(MonsterBase.instance_counts[monster])
	out += "\n".join(monsters)
	return out
