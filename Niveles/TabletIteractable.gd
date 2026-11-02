extends StaticBody3D

@export var target_task_id: String = "encender_tablet"
@export var prompt_mensaje: String = "Presiona E para encender"
@onready var boton_tablet_player: AudioStreamPlayer3D =  $click
@onready var sonido_evento: AudioStreamPlayer3D = $evento_pasos
@export var tiempo_bloqueo: float = 1.0

# Esta función será llamada por el RayCast del jugador
func interact() -> void:
	var current_task = TaskManager.get_current_task()
	
	# Verificamos si la tarea actual coincide con la de este objeto
	if current_task and current_task.id == target_task_id and not current_task.is_completed:
		print("Tablet encendida")
		
		# Completamos la tarea en el Autoload
		TaskManager.complete_task(target_task_id)
		
		boton_tablet_player.play()
		if sonido_evento and not sonido_evento.playing:
			sonido_evento.play()
		
	else:
		print("No puedes interactuar con esto ahora mismo o ya fue completado.")
