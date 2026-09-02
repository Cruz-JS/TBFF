extends Label

# Add this line to the very top of your Label's _ready() function:
func _ready() -> void:
	if label_settings:
		label_settings = label_settings.duplicate() # Makes this label's settings unique
	
	var parent = get_parent()
	if parent and parent.has_signal("clicked"):
		parent.clicked.connect(_on_parent_clicked)
	if parent and parent.has_signal("released"):
		parent.released.connect(_on_parent_released)

# Accept the button parameter passed by the signal
func _on_parent_clicked(button_node: Node) -> void:
	# Gatekeeper: only proceed if THIS label's parent equals the clicked button
	if button_node == get_parent():
		label_settings.font_size = 55
		label_settings.font_color = Color8(200, 200, 200)
	
func _on_parent_released(button_node: Node) -> void:
	# Gatekeeper: only proceed if THIS label's parent equals the released button
	if button_node == get_parent():
		label_settings.font_size = 60
		label_settings.font_color = Color8(255, 255, 255)
