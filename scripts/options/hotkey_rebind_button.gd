extends Control

@export var action_name : String = ""
var current_state: bool = false;

func _ready():
	var events = InputMap.action_get_events(action_name)
	var event = events[0]
	var key_text = event.as_text().to_upper()
	if key_text.ends_with("(PHYSICAL)"):
		key_text = key_text.replace("(PHYSICAL)", "").strip_edges()
	self.text = key_text
	
	self.button_pressed = false
	self.toggled.connect(_toggled)

func _toggled(toggled_on: bool):
	current_state = toggled_on;
	if toggled_on:
		set_process_unhandled_key_input(toggled_on)
	else:
		set_process_unhandled_key_input(toggled_on)


func _unhandled_key_input(event: InputEvent) -> void:
	if current_state:
		rebind_action_key(event)
	self.button_pressed = false
	
func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	self.text = "%s" % OS.get_keycode_string(event.physical_keycode);
	set_process_unhandled_key_input(false)
