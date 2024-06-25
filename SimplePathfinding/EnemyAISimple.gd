extends CharacterBody3D

@export var movement_speed: float = 2.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
@export var target: Node3D
@export var patrolpoints: Node
var targetPosition:Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_patrol_point_index = 0

func _ready() -> void:
	print(patrolpoints)
	if patrolpoints == null or patrolpoints.get_child_count() == 0:
		target = self
	else:
		target = patrolpoints.get_children()[target_patrol_point_index]
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	#target = patrolpoints.get_children()[target_patrol_point_index]
	print(target.position)
	targetPosition = target.position
	

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	set_movement_target(target.position)
	if target.position != self.position:
		var rayPOS = target.position
		rayPOS.y = self.position.y
		#look_at(rayPOS)
		
		look_at(transform.origin + velocity,Vector3.UP)
		
		#var T = transform.looking_at(target.global_transform.origin, Vector3.UP)
		#global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, delta*2)
		#global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, delta*2)
		#global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, delta*2)
		#position = position.lerp(transform.origin + velocity, delta * 2)
		
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if navigation_agent.is_navigation_finished():
		print("Arrived at patrol point")
		if patrolpoints == null or patrolpoints.get_child_count() == 0:
			return
		target_patrol_point_index = randi_range(0, patrolpoints.get_child_count()-1)
		print("New patrol point: " + str(target_patrol_point_index))
		target = patrolpoints.get_children()[target_patrol_point_index]
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

