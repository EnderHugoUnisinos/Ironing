extends CharacterBody3D

@export var waddle_speed: float = 1.0
@export var ironing_speed: float = 10.0
@export var max_speed: float = 15.0
@export var standing_jump_height: float = 4.0
@export var ironing_jump_height: float = 5.0
@export var health: float = 50.0
@export var cooldown: float = 1.2

@onready var animation_tree = $Iron/AnimationTree
@onready var camera: Camera3D = $Pivot/Camera3D
@onready var timer: Timer = $CooldownTimer
@onready var pivot = $Pivot
@onready var model = $Iron
@onready var collision_top = $CollisionTop
@onready var collision_bottom = $CollisionBottom
@onready var front_ray = $CollisionBottom/FrontRay
@onready var rear_ray = $CollisionBottom/RearRay
@onready var ground_ray = $CollisionBottom/GroundRay
@onready var ramp_ray = $CollisionBottom/RampRay
@onready var left_ray = $CollisionBottom/LeftRay
@onready var right_ray = $CollisionBottom/RightRay

enum iron_mode {STANDING, IRONING}
var current_mode : iron_mode = iron_mode.STANDING
var walk = false
var jumping = false
var last_y_position: float

func _ready() -> void:
	last_y_position = self.global_position.y

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		Input.MouseMode.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("unlock_mouse"):
		Input.MouseMode.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("reset"):
		get_parent().get_tree().reload_current_scene()
	if Input.is_action_just_pressed("special"):
		if timer.time_left == 0 and is_on_floor():
			switch_mode()

func switch_mode():
	timer.start(cooldown)
	if current_mode == iron_mode.STANDING:
		current_mode = iron_mode.IRONING
		walk = false
		self.floor_stop_on_slope = false
	else:
		current_mode = iron_mode.STANDING
		self.floor_stop_on_slope = true

func _process(delta: float) -> void:
	if (self.velocity.x > 0.01 or self.velocity.x < -0.01) or (self.velocity.z > 0.01 or self.velocity.z < -0.01):
		walk = true
	else:
		walk = false
		

func _physics_process(delta: float) -> void:
	var input_vec := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)
	if is_on_floor():
		jumping = false
	if Input.is_action_just_pressed("jump") and !jumping and timer.time_left == 0:
		var jump_height: float
		if current_mode == iron_mode.IRONING:
			jump_height = ironing_jump_height
		else:
			jump_height = standing_jump_height
		self.velocity.y = jump_height
		jumping = true
		
	if input_vec.length() > 0:
		input_vec = input_vec.normalized()
		
		# Get camera basis (direction vectors)
		var cam_transform := camera.global_transform.basis
		var cam_forward := -cam_transform.z
		var cam_right := cam_transform.x
		# Ignore Y (flatten the vectors)
		cam_forward.y = 0
		cam_right.y = 0
		cam_forward = cam_forward.normalized()
		cam_right = cam_right.normalized()


		# Move relative to camera
		var direction := (cam_forward * input_vec.y) + (cam_right * input_vec.x)
		if timer.time_left == 0:
			if current_mode == iron_mode.STANDING:
					velocity.x = direction.x * waddle_speed
					velocity.z = direction.z * waddle_speed
			if current_mode == iron_mode.IRONING:
					velocity.x =  clamp(velocity.x + (direction.x * ironing_speed * delta), -max_speed, max_speed)
					velocity.z = clamp(velocity.z + (direction.z * ironing_speed * delta), -max_speed, max_speed)
				
		model.rotation.y = rotate_toward(model.rotation.y, atan2(-velocity.x,-velocity.z), 0.5)
			
		if timer.time_left > 0:
			velocity.x = move_toward(velocity.x, 0, 0.02)
			velocity.z = move_toward(velocity.z, 0, 0.02)
	else:
		if is_on_floor():
			model.rotation.y = rotate_toward(model.rotation.y, atan2(-velocity.x,-velocity.z), 0.1)
			if current_mode == iron_mode.IRONING or timer.time_left > 0:
				velocity -= velocity * min(delta/0.3, 1.0)
			else:
				velocity -= velocity * min(delta/0.1, 1.0)
		else:
				velocity -= velocity * min(delta/0.9, 1.0)
	
	collision_top.rotation.y = model.rotation.y
	collision_bottom.rotation.y = model.rotation.y
	if !is_on_floor():
		velocity.y = velocity.y - (6*delta)
	elif (!ground_ray.is_colliding()):
		var nl = left_ray.get_collision_normal() if left_ray.is_colliding() else Vector3.UP
		var nr = right_ray.get_collision_normal() if right_ray.is_colliding() else Vector3.UP
		
		var n = ((nr + nr) / 2.0).normalized()
		var xform = align_with_y(global_transform, n)
		transform = transform.interpolate_with(xform, 0.4)
		
	# If either side is in the air, align to slope.
	if (front_ray.is_colliding() or rear_ray.is_colliding()):
		if ((ground_ray.is_colliding() and !self.is_on_floor()) or ramp_ray.is_colliding()): 
			# If one side is in air, move it do
			var nr = rear_ray.get_collision_normal() if rear_ray.is_colliding() else ground_ray.get_collision_normal()
			var nf = front_ray.get_collision_normal() if front_ray.is_colliding() else ground_ray.get_collision_normal()
			
			#var ng = ground_ray.get_collision_normal() if ground_ray.is_colliding() else Vector3.UP
			
			#var n = ((ng + Vector3.UP)/2).normalized()
			#var n = ng.normalized()
			
			var n = ((nr + nf) / 2.0).normalized()
			var xform = align_with_y(global_transform, n)
			transform = transform.interpolate_with(xform, 0.4)
		
	move_and_slide()
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
