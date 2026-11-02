extends StaticBody3D

@export var target_task_id: String = "desactivar_alarma"
@export var prompt_mensaje: String = "Presiona E para desactivar alarma"
@onready var boton_alarma_player: AudioStreamPlayer3D = $AlarmaDesactivada
@export var tiempo_bloqueo: float = 3.0

func interact() -> void:
	var current_task = TaskManager.get_current_task()
	if current_task and current_task.id == target_task_id and not current_task.is_completed:
		print("¡Alarma desactivada!")
		TaskManager.complete_task(target_task_id)
		
		boton_alarma_player.play()
		await get_tree().create_timer(3.0).timeout
		# Notificamos a la zona de la puerta para apagar el audio y cancelar el timer
		get_tree().call_group("alarma_zona", "detener_alarma")
