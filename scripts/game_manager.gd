extends Node

class_name GameManager

@export var maxEnemyPoolSize = 100
@export var enemyScene: PackedScene
@export var enemyPoolHolder: Node3D
var enemyPool: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(maxEnemyPoolSize):
		var instance = enemyScene.instantiate()
		enemyPoolHolder.add_child(instance)
		instance.position = Vector3(i * (-1 ** i), 0, i * (-1 ** i))
		#instance.set_process(false)
		#instance.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
