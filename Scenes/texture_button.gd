extends TextureButton

var Button_Name: String

# Pass the button itself as an argument
signal clicked(button_node)
signal released(button_node)

const CLICKED_SCALE := Vector2(0.95, 0.95)
const NORMAL_SCALE := Vector2(1.0, 1.0)
const TWEEN_DURATION := 0.05

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	pivot_offset = size / 2
	Button_Name = name

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if event.pressed:
			# Pass 'self' through the signal
			clicked.emit(self)
			print(Button_Name, " Was clicked!")
			
			var tween = create_tween()
			tween.tween_property(self, "scale", CLICKED_SCALE, TWEEN_DURATION)
			
			if Button_Name == "TBFF Wiki":
				OS.shell_open("https://thebattleforfallon.com")
				
		else:
			# Pass 'self' through the signal
			released.emit(self)
			
			var tween = create_tween()
			tween.tween_property(self, "scale", NORMAL_SCALE, TWEEN_DURATION)
