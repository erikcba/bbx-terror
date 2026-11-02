extends StaticBody3D

@export var target_task_id: String = "encender_luces"
@export var prompt_mensaje: String = "Presiona E para encender luces"
@onready var boton_termica_player: AudioStreamPlayer3D = $SubirTermicas
@export var luz_objetivo: Array[Light3D]
@export var tiempo_bloqueo: float = 2.0

# Esta función será llamada por el RayCast del jugador
func interact() -> void:
	var current_task = TaskManager.get_current_task()
	
	# Verificamos si la tarea actual coincide con la de este objeto
	if current_task and current_task.id == target_task_id and not current_task.is_completed:
		print("Luces encendidas")
		
		# Completamos la tarea en el Autoload
		TaskManager.complete_task(target_task_id)
		
		# Opcional: Reproducir sonido de desactivación o cambiar la luz del panel a verde
		boton_termica_player.play()
		for luz in luz_objetivo:
			if luz:
				luz.visible = true
		
		# Desactivamos el objeto para que no se pueda volver a interactuar
		#queue_free() 
	else:
		print("No puedes interactuar con esto ahora mismo o ya fue completado.")
