class_name DebugDisplay
extends RichTextLabel

static var instance: DebugDisplay
static var lines = PackedStringArray()
static var changed = false

func _ready() -> void:
	instance = self

static func set_line(line: int, val: String):
	if lines.size() < line + 1:
		lines.resize(line + 1)
	lines[line] = val
	changed = true

func _process(_delta: float):
	if !changed:
		return
	text = "\n".join(lines)
	print(text)
