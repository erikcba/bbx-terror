extends Area3D

@export var target_task_id: String = "desactivar_alarma"
@export var alarm_player: AudioStreamPlayer3D

var cuenta_regresiva_activa: bool = false
var temporizador_cancelado: bool = false

func _ready() -> void:
	add_to_group("alarma_zona") # Asignamos el grupo por código para asegurar
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not cuenta_regresiva_activa:
		# Si la tarea ya está hecha, no hacemos nada
		if TaskManager.is_task_completed(target_task_id):
			return
			
		cuenta_regresiva_activa = true
		temporizador_cancelado = false
		print("¡Has cruzado la puerta! Tienes 5 segundos...")
		
		# Esperamos los 5 segundos
		await get_tree().create_timer(5.0).timeout
		
		# REVISIÓN DOBLE: Si no fue cancelado manualmente Y la tarea sigue sin hacerse
		if not temporizador_cancelado and not TaskManager.is_task_completed(target_task_id):
			print("¡TIEMPO AGOTADO! ¡ALARMA ACTIVADA!")
			if alarm_player and not alarm_player.playing:
				alarm_player.play()
				
		cuenta_regresiva_activa = false

# Esta función es llamada desde el panel interactivo
func detener_alarma() -> void:
	temporizador_cancelado = true
	if alarm_player:
		alarm_player.stop()
	print("Alarma silenciada y temporizador cancelado.")
