extends Camera3D

@export var target: Node3D

var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(target.global_transform.origin, Vector3.UP)
	%PathFollow3D.progress += speed * delta
	pass
