extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition():
	skip_emit = false
	$AnimationPlayer.play("default")
	await transitioned_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")


func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	self.get_tree().change_scene_to_file(scene_path)


func emit_transitioned_halfway():
	if skip_emit:
		return
	
	transitioned_halfway.emit()
