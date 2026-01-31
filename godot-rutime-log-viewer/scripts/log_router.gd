# res://autoloads/log_router.gd
extends Node

signal log_message(message: String, is_error: bool)
signal log_error(message: String)
signal log_display(has_drawn: bool)

class log_router extends Logger:
	var _mutex := Mutex.new()
	var _queue: Array = []

	func _log_message(message: String, error: bool) -> void:
		_mutex.lock()
		_queue.append({"type": "message", "message": message, "is_error": error})
		_mutex.unlock()

	func _log_error(function: String, file: String, line: int, code: String,
		rationale: String, editor_notify: bool, error_type: int,
		script_backtraces: Array[ScriptBacktrace]) -> void:
		_mutex.lock()
		_queue.append({
			"type": "error",
			"time_ms": Time.get_ticks_msec(),
			"function": function,
			"file": file,
			"line": line,
			"code": code,
			"rationale": rationale,
			"editor_notify": editor_notify,
			"error_type": error_type,
			"script_backtraces": script_backtraces,
		})
		_mutex.unlock()


	func pop_all() -> Array:
		_mutex.lock()
		var items := _queue.duplicate()
		_queue.clear()
		_mutex.unlock()
		return items

var num_of_circle_to_show: int = 1
var min_point_distance: float = 10.0

var gesture_detector: Array[Vector2] = []
var gesture_count: int = 0

var active_touch_id: int = -1
var is_mouse_drawing: bool = false

var waiting_for_release: bool = false 
var _logger: log_router

func _init() -> void:
	_logger = log_router.new()
	OS.add_logger(_logger)

func _process(_delta: float) -> void:
	for item in _logger.pop_all():
		if item.type == "message":
			emit_signal("log_message", item.message, item.is_error)
		else:
			var msg: String = str(item.get("rationale", ""))
			if msg == "":
				msg = str(item.get("code", ""))

			var time_str := _format_time(int(item.get("time_ms", 0)))
			var header := "E %s   %s: %s" % [time_str, item.get("function", ""), msg]
			var source := "<GDScript Source>%s:%d @ %s" % [
				item.get("file", ""),
				int(item.get("line", 0)),
				item.get("function", "")
			]

			var trace := ""
			var traces: Array = item.get("script_backtraces", [])
			for bt in traces:
				if bt is ScriptBacktrace and bt.get_language_name() == "GDScript":
					var formatted: String = bt.format(0, 0).strip_edges()
					if formatted != "":
						trace = "<Stack Trace> " + formatted.replace("\n", "\n<Stack Trace> ")
				break
			var output_string = header + "\n" + source + "\n" + trace + "\n"
			emit_signal("log_error", output_string)
	if is_gesture_done():
		log_display.emit(true)
		pass
				
func _format_time(ms: int) -> String:
	var ms_part = ms % 1000
	var total_sec = ms / 1000
	var sec = total_sec % 60
	var total_min = total_sec / 60
	var min = total_min % 60
	var hours = total_min / 60
	return "%d:%02d:%02d:%03d" % [hours, min, sec, ms_part]



func _unhandled_input(event: InputEvent) -> void:
	# --- Touch ---
	if event is InputEventScreenTouch:
		if event.pressed:
			active_touch_id = event.index
			waiting_for_release = false
			gesture_detector.clear()
			gesture_detector.append(event.position)
		else:
			if event.index == active_touch_id:
				gesture_detector.clear()
				active_touch_id = -1
				waiting_for_release = false

	elif event is InputEventScreenDrag:
		if event.index == active_touch_id:
			if waiting_for_release:
				return
			var p = event.position
			if gesture_detector.is_empty() or (p - gesture_detector[-1]).length() > min_point_distance:
				gesture_detector.append(p)

	# --- Mouse (desktop testing) ---
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_mouse_drawing = true
			waiting_for_release = false
			gesture_detector.clear()
			gesture_detector.append(event.position)
		else:
			is_mouse_drawing = false
			gesture_detector.clear()
			waiting_for_release = false

	elif event is InputEventMouseMotion and is_mouse_drawing:
		if waiting_for_release:
			return
		var p2 = event.position
		if gesture_detector.is_empty() or (p2 - gesture_detector[-1]).length() > min_point_distance:
			gesture_detector.append(p2)

func is_gesture_done() -> bool:
	if waiting_for_release:
		return false

	if gesture_detector.size() < 10:
		return false

	var gesture_sum := Vector2.ZERO
	var gesture_length := 0.0
	var prev_delta := Vector2.ZERO

	for i in range(gesture_detector.size() - 2):
		var delta := gesture_detector[i + 1] - gesture_detector[i]
		gesture_sum += delta
		gesture_length += delta.length()

		if delta.dot(prev_delta) < 0.0:
			gesture_detector.clear()
			gesture_count = 0
			return false

		prev_delta = delta

	var rect := get_viewport().get_visible_rect().size
	var gesture_base := (rect.x + rect.y) / 4.0

	if gesture_length > gesture_base and gesture_sum.length() < (gesture_base / 2.0):
		gesture_detector.clear()
		gesture_count += 1

		if gesture_count >= num_of_circle_to_show:
			gesture_count = 0
			waiting_for_release = true 
			return true

	return false
