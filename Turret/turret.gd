extends Node3D

@export var projectile: PackedScene
@export var turret_range := 10.0

var enemy_path: Path3D
var target: PathFollow3D

@onready var turret_top: Node3D = $TurretBase/TurretTop
@onready var fire_animation: AnimationPlayer = $AnimationPlayer
@onready var turret_base: Node3D = $TurretBase
@onready var cannon: Node3D = $TurretBase/TurretTop/Cannon


func _on_timer_timeout() -> void:
	if target:
		var shot = projectile.instantiate()
		add_child(shot)
		fire_animation.play("fire")
		shot.global_position = cannon.global_position
		shot.direction = turret_base.global_transform.basis.z
	
func _physics_process(delta: float) -> void:
	target = find_best_target()
	if target:
		turret_base.look_at(target.global_position, Vector3.UP, true)

func find_best_target() -> PathFollow3D:
	var best_target = null
	var best_progress = 0
	for enemy in enemy_path.get_children():
		if enemy is PathFollow3D:
			if enemy.progress > best_progress:
				var distance := global_position.distance_to(enemy.global_position)
				if distance < turret_range:
					best_target = enemy
					best_progress = enemy.progress
	return best_target
