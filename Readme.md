# Godot Runtime Log Viewer

A small in-game log viewer for Godot 4 that captures engine log output at runtime and renders it in a UI panel. It is designed for mobile and desktop and can be opened with a simple gesture.

## Features
- Captures log output via a custom `Logger` and forwards it to the UI.
- Displays both regular messages and error traces.
- Toggleable log window with a circular gesture (or mouse drag during desktop testing).
- Simple UI with clear, settings, and close actions.

## Requirements
- Godot 4.x (project config targets 4.5)

## Installation
1. Copy the `godot-rutime-log-viewer` folder into your project (keep the same folder name).
2. Add the logger autoload in `project.godot` (already configured in this repo):
   - Name: `LogRouter`
   - Path: `res://godot-rutime-log-viewer/scripts/log_router.gd`
3. Instance the viewer scene somewhere in your UI:
   - `res://godot-rutime-log-viewer/scenes/log_viewer_canvas_scene.tscn`

## Usage
1. Run your project.
2. Draw a circle on the screen to show the log window.
   - For desktop testing, hold the left mouse button and draw a circle.
3. Logs written with `print()` and `push_error()` will appear in the viewer.

### Example
```gdscript
func _ready() -> void:
    print("Hello from runtime log viewer")
    push_error("Something went wrong at runtime!")
```

## Testing Scene
You can try the included test scene:
- `res://godot-rutime-log-viewer/testing/scenes/testing_scene_main.tscn`

It spawns the log viewer and emits sample logs on startup.

## Folder Layout
```
godot-rutime-log-viewer/
  scenes/
  scripts/
  testing/
```

## Contributing
Feel free to raise an issue for suggestions or problems. Pull requests are welcome as well.

If you are submitting a PR, please describe the change and include repro steps or screenshots when relevant.

Check CONTRIBUTING.md

## License
MIT, please check LICENSE FILE