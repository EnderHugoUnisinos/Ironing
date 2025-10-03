extends MovementBase

@export var waddle_speed: float = 1.0
@export var ironing_speed: float = 10.0
@export var max_speed: float = 15.0
@export var standing_jump_height: float = 4.0
@export var ironing_jump_height: float = 5.0
@export var health: float = 50.0
@export var cooldown: float = 1.2

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var timer: Timer = $CooldownTimer
@onready var camera_pivot = $CameraPivot
@onready var character_pivot = $CharacterPivot
#@onready var model = $CharacterPivot/Iron
@onready var collision_ironing = $CollisionIroning
@onready var collision_standing = $CollisionStanding
@onready var ground_ray = $GroundRay

enum iron_mode {STANDING, IRONING}
var current_mode : iron_mode = iron_mode.STANDING
var walk = false
var jumping = false
var current_speed = 1
var last_y_position: float
var last_floor_normal: Vector3
var last_floor_point: Vector3
var last_grounded_velocity: Vector3

func _ready() -> void:
	last_y_position = self.global_position.y

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		Input.MouseMode.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("unlock_mouse"):
		Input.MouseMode.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("reset"):
		get_parent().get_tree().reload_current_scene()

func switch_mode(switch_mode):
	if switch_mode == iron_mode.IRONING:
		timer.start(cooldown)
		current_mode = iron_mode.IRONING
		walk = false
		collision_ironing.disabled = false
		collision_standing.disabled = true
		self.floor_stop_on_slope = false
	elif switch_mode == iron_mode.STANDING :
		timer.start(cooldown)
		current_mode = iron_mode.STANDING
		collision_ironing.disabled = true
		collision_standing.disabled = false
		self.floor_stop_on_slope = true

func _process(delta: float) -> void:
	if (self.velocity.x > 0.01 or self.velocity.x < -0.01) or (self.velocity.z > 0.01 or self.velocity.z < -0.01):
		walk = true
	else:
		walk = false
	if Input.is_action_pressed("special"):
		if timer.time_left == 0 and is_on_floor() and current_mode != iron_mode.IRONING:
			switch_mode(iron_mode.IRONING)
	elif !Input.is_action_pressed("special"):
		if timer.time_left == 0 and is_on_floor() and current_mode != iron_mode.STANDING:
			switch_mode(iron_mode.STANDING)

func _physics_process(delta: float) -> void:
	var input_vec := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)
	if is_on_floor():
		jumping = false
	if input_vec.length() > 0:
		input_vec = input_vec.normalized()
		
		# Get camera basis (direction vectors)
		var cam_transform := (camera.global_transform.basis)
		var cam_forward := -cam_transform.z
		var cam_right := cam_transform.x
		
		cam_forward = cam_forward.slide(last_floor_normal.normalized()).normalized()
		cam_right = cam_right.slide(last_floor_normal.normalized()).normalized()

		var direction := (cam_forward * input_vec.y) + (cam_right * input_vec.x)
		direction = direction.slide(last_floor_normal)
		#direction.y += 0.1
		if (current_mode == iron_mode.STANDING and (timer.time_left == 0)) or (current_mode == iron_mode.IRONING and !(timer.time_left == 0)):
			velocity.x = direction.x * waddle_speed
			velocity.y = direction.y * waddle_speed
			velocity.z = direction.z * waddle_speed
		if (current_mode == iron_mode.IRONING and (timer.time_left == 0)) or (current_mode == iron_mode.STANDING and !(timer.time_left == 0)):
			velocity.x =  clamp(velocity.x + (direction.x * ironing_speed * delta), -max_speed, max_speed)
			velocity.y =  clamp(velocity.y + (direction.y * ironing_speed * delta * 5), -max_speed, max_speed)
			velocity.z = clamp(velocity.z + (direction.z * ironing_speed * delta), -max_speed, max_speed)
			
		character_pivot.rotation.y = rotate_toward(character_pivot.rotation.y, atan2(-velocity.x,-velocity.z), 0.5)
		if timer.time_left > 0:
			velocity.x = move_toward(velocity.x, 0, 0.02)
			velocity.z = move_toward(velocity.z, 0, 0.02)
	else:
		if is_on_floor():
			character_pivot.rotation.y = rotate_toward(character_pivot.rotation.y, atan2(-velocity.x,-velocity.z), 0.1)
			if current_mode == iron_mode.IRONING or timer.time_left > 0:
				velocity -= velocity * min(delta/0.1, 1.0)
			else:
				velocity -= velocity * min(delta/0.1, 1.0)
		else:
			velocity -= velocity * min(delta/0.9, 1.0)
	
	if Input.is_action_just_pressed("jump") and !jumping:
		var jump_height: float
		if current_mode == iron_mode.IRONING:
			jump_height = ironing_jump_height
			$GPUParticles3D.restart()
		else:
			jump_height = standing_jump_height
		self.velocity.y = jump_height
		jumping = true
	##Gravity
	if !is_on_floor():
		velocity.y = velocity.y - (9.2*delta)
	#if (!ground_ray.is_colliding()):
		#var nl = Vector3.UP
		#var nr =  Vector3.UP
		#var n = ((nr + nr) / 2.0).normalized()
		#var xform = align_with_y(global_transform, n)
		#transform = transform.interpolate_with(xform, 0.4)
		
	# If either side is in the air, align to slope.
	if (front_ray.is_colliding() or rear_ray.is_colliding()) and self.is_on_floor():
		if ground_ray.is_colliding():
			## If one side is in air, move it do
			#var nr = rear_ray.get_collision_normal() if rear_ray.is_colliding() else ground_ray.get_collision_normal()
			#var nf = front_ray.get_collision_normal() if front_ray.is_colliding() else ground_ray.get_collision_normal()
		#
			#var n = ((nr + nf) / 2.0).normalized()
			var n = ground_ray.get_collision_normal().normalized()
			var xform = align_with_y(character_pivot.transform, n)
			character_pivot.transform = character_pivot.transform.interpolate_with(xform, 0.4)
			
	if ground_ray.is_colliding():
		last_floor_normal = ground_ray.get_collision_normal().normalized()
	if !is_on_floor():
		last_floor_normal.x = move_toward(last_floor_normal.x, 0, ((9.2)*delta))
		last_floor_normal.y = move_toward(last_floor_normal.y, 1, ((9.2)*delta))
		last_floor_normal.z = move_toward(last_floor_normal.z, 0, ((9.2)*delta))
		last_floor_normal = last_floor_normal.normalized()
	
	floor_snap_length = 0.5
	move_and_slide()
