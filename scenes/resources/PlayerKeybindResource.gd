class_name PlayerKeybindResource
extends Resource

const FORWARD : String = "forward"
const BACKWARD : String = "backward"
const LEFT : String = "left"
const RIGHT : String = "right"
const SPECIAL : String = "special"
const JUMP : String = "jump"
const RESET : String = "reset"

@export var DEFAULT_FORWARD = InputEventKey.new()
@export var DEFAULT_BACKWARD = InputEventKey.new()
@export var DEFAULT_LEFT = InputEventKey.new()
@export var DEFAULT_RIGHT = InputEventKey.new()
@export var DEFAULT_SPECIAL = InputEventKey.new() 
@export var DEFAULT_JUMP = InputEventKey.new() 
@export var DEFAULT_RESET = InputEventKey.new()
 
var forward_key = InputEventKey.new()
var backward_key = InputEventKey.new() 
var left_key = InputEventKey.new()
var right_key = InputEventKey.new()
var special_key = InputEventKey.new()
var jump_key = InputEventKey.new()
var reset_key = InputEventKey.new() 
