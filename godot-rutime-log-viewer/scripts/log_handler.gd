extends Node2D

@onready var label := $Label

func _ready() -> void:
	LogRouter.log_message.connect(_on_log_message)
	LogRouter.log_error.connect(_on_log_error)

func _on_log_message(message: String, is_error: bool) -> void:
	label.text += message + "\n"

func _format_time(ms: int) -> String:
	var ms_part = ms % 1000
	var total_sec = ms / 1000
	var sec = total_sec % 60
	var total_min = total_sec / 60
	var min = total_min % 60
	var hours = total_min / 60
	return "%d:%02d:%02d:%03d" % [hours, min, sec, ms_part]

func _on_log_error(data: Dictionary) -> void:
	var msg: String = str(data.get("rationale", ""))
	if msg == "":
		msg = str(data.get("code", ""))

	var time_str := _format_time(int(data.get("time_ms", 0)))
	var header := "E %s   %s: %s" % [time_str, data.get("function", ""), msg]
	var source := "<GDScript Source>%s:%d @ %s" % [
		data.get("file", ""),
		int(data.get("line", 0)),
		data.get("function", "")
	]

	var trace := ""
	var traces: Array = data.get("script_backtraces", [])
	for bt in traces:
		if bt is ScriptBacktrace and bt.get_language_name() == "GDScript":
			var formatted: String = bt.format(0, 0).strip_edges()
			if formatted != "":
				trace = "<Stack Trace> " + formatted.replace("\n", "\n<Stack Trace> ")
		break


	label.text += header + "\n" + source + "\n" + trace + "\n"
