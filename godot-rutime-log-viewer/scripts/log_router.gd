# res://autoloads/log_router.gd
extends Node

signal log_message(message: String, is_error: bool)
signal log_error(data: Dictionary)

class CustomLogger extends Logger:
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

var _logger: CustomLogger

func _init() -> void:
	_logger = CustomLogger.new()
	OS.add_logger(_logger)

func _process(_delta: float) -> void:
	for item in _logger.pop_all():
		if item.type == "message":
			emit_signal("log_message", item.message, item.is_error)
		else:
			emit_signal("log_error", item)
