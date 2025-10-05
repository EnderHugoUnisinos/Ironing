extends MovementBase

@export var waddle_speed: float = 2.5
@export var ironing_speed: float = 15.0
@export var max_speed: float = 15.0
@export var standing_jump_height: float = 4.0
@export var ironing_jump_height: float = 5.0
@export var health: float = 50.0
@export var cooldown: float = 1.2

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var timer: Timer = $CooldownTimer
#@onready var camera_pivot = $CameraPivot
@onready var character_pivot = $CharacterPivot
#@onready var model = $CharacterPivot/Iron
@onready var collision_ironing = $CollisionIroning
@onready var collision_standing = $CollisionStanding
@onready var ground_ray = $GroundRay
@onready var water_meter : ProgressBar = $Hud/WaterMeter

enum iron_mode {STANDING, IRONING}
var current_mode : iron_mode = iron_mode.STANDING
var walk = false
var jumping = false
var current_speed = waddle_speed
var current_jump_height = standing_jump_height
var last_y_position: float
var last_floor_normal: Vector3
var last_floor_point: Vector3
var last_grounded_velocity: Vector3
var current_floor_collider: CollisionShape3D

func _ready() -> void:
	last_y_position = self.global_position.y

func switch_mode(switch_mode):
	if switch_mode == iron_mode.IRONING:
		timer.start(cooldown)
		current_mode = iron_mode.IRONING
		current_speed = ironing_speed
		current_jump_height = ironing_jump_height
		walk = false
		collision_ironing.disabled = false
		collision_standing.disabled = true
		self.floor_stop_on_slope = false
	elif switch_mode == iron_mode.STANDING :
		timer.start(cooldown)
		current_mode = iron_mode.STANDING
		current_speed = waddle_speed
		current_jump_height = standing_jump_height
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
	if last_floor_normal == Vector3.ZERO:
		last_floor_normal = Vector3.UP.normalized()
	var input_vec := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)
	if is_on_floor():
		jumping = false
		#region reset surface changes
		if current_mode == iron_mode.IRONING:
			current_speed = ironing_speed
			current_jump_height = ironing_jump_height
		else:
			current_speed = waddle_speed
			current_jump_height = standing_jump_height
		#endregion
	if input_vec.length() > 0:
		input_vec = input_vec.normalized()
		if current_floor_collider:
			if current_floor_collider.get_script():
				if (current_mode == iron_mode.IRONING and timer.time_left == 0) or (current_mode != iron_mode.IRONING and timer.time_left != 0):
					current_floor_collider.surface_iron(self)
				else:
					current_floor_collider.surface_walk(self)
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
			velocity.y = direction.y * waddle_speed + velocity.y
			velocity.z = direction.z * waddle_speed
		if (current_mode == iron_mode.IRONING and (timer.time_left == 0)) or (current_mode == iron_mode.STANDING and !(timer.time_left == 0)):
			velocity.x = move_toward(velocity.x, direction.x*current_speed, (current_speed * delta)+abs(direction.x)*delta*10)
			velocity.y =  clamp(velocity.y + (direction.y * current_speed * delta * 5), -max_speed, max_speed)
			velocity.z = move_toward(velocity.z, direction.z*current_speed, (current_speed * delta)+abs(direction.z)*delta*10)
			
		character_pivot.rotation.y = rotate_toward(character_pivot.rotation.y, atan2(-velocity.x,-velocity.z)+(randf()*0.02), 0.5)
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
		if current_floor_collider:
			if current_floor_collider.get_script():
				current_floor_collider.surface_jump(self)
		if current_mode == iron_mode.IRONING:
			$GPUParticles3D.restart()
		self.velocity.y = current_jump_height
		jumping = true
	##Gravity
	if !is_on_floor():
		velocity.y = velocity.y - (11.2*delta)
	if !self.is_on_floor():
		var n = Vector3.UP.normalized()
		var xform = align_with_y(character_pivot.transform, n)
		character_pivot.transform = character_pivot.transform.interpolate_with(xform, 0.01)
		
	if self.is_on_floor():
		if ground_ray.is_colliding():
			var n = ground_ray.get_collision_normal().normalized()
			var xform = align_with_y(character_pivot.transform, n)
			character_pivot.transform = character_pivot.transform.interpolate_with(xform, 0.4)	
	if ground_ray.is_colliding():
		last_floor_normal = get_floor_normal().normalized()
		var target = ground_ray.get_collider()
		var shape_id = ground_ray.get_collider_shape()
		current_floor_collider = target.shape_owner_get_owner(shape_id)
		
	if !is_on_floor():
		last_floor_normal.x = move_toward(last_floor_normal.x, 0, ((9.2)*delta))
		last_floor_normal.y = move_toward(last_floor_normal.y, 1, ((9.2)*delta))
		last_floor_normal.z = move_toward(last_floor_normal.z, 0, ((9.2)*delta))
		last_floor_normal = last_floor_normal.normalized()
	floor_snap_length = 0.5
	move_and_slide()
