extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition():
	skip_emit = false
	$AnimationPlayer.play("default")
	await transitioned_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")


func emit_transitioned_halfway():
	print(skip_emit)
	if skip_emit:
		return
	
	transitioned_halfway.emit()
