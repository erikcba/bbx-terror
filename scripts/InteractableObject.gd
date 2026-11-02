extends StaticBody3D

@export var target_task_id: String = "desactivar_alarma"

func interact() -> void:
	var current_task = TaskManager.get_current_task()
	if current_task and current_task.id == target_task_id:
		print("¡Alarma desactivada!")
		# Reproducir sonido de beep de desactivación aquí
		TaskManager.complete_task(target_task_id)
		queue_free() # O desactiva el objeto para que no se vuelva a interactuar
