# res://autoloads/log_router.gd
extends Node

signal log_message(message: String, is_error: bool)
signal log_error(message: String)

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
			
func _format_time(ms: int) -> String:
	var ms_part = ms % 1000
	var total_sec = ms / 1000
	var sec = total_sec % 60
	var total_min = total_sec / 60
	var min = total_min % 60
	var hours = total_min / 60
	return "%d:%02d:%02d:%03d" % [hours, min, sec, ms_part]
