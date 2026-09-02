extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var game_version: String = ProjectSettings.get_setting("application/config/version")
	
	# 'text' directly modifies this Label's text property
	text = "Version " + game_version 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
