extends Node

# Señales para notificar al HUD
signal task_updated(task_description: String)
signal task_completed(task_id: String)
signal all_tasks_completed()

# Lista de tareas y control de índice
var current_tasks: Array = []
var current_index: int = 0

func _ready() -> void:
	# Carga tus tareas aquí (puedes agregar tantas como necesites)
	cargar_tareas()
	

func cargar_tareas() -> void:
	# Ruta de tu primera tarea
	var tarea_alarma = load("res://tasks/tarea_alarma.tres")
	if tarea_alarma:
		current_tasks.append(tarea_alarma)
		
	var tarea_segunda = load("res://tasks/marcar_entrada.tres")
	if tarea_segunda:
		current_tasks.append(tarea_segunda)
		
	# Ruta de tu segunda tarea (ejemplo: encender luces, revisar puertas, etc.)
	var tarea_tercera = load("res://tasks/tarea_encender_luces.tres")
	if tarea_tercera:
		current_tasks.append(tarea_tercera)
		
	var tarea_cuarta = load("res://tasks/encender_tablet.tres")
	if tarea_cuarta:
		current_tasks.append(tarea_cuarta)
	
	print("Tareas cargadas en total: ", current_tasks.size())

# Devuelve la tarea activa actual
func get_current_task():
	if current_index < current_tasks.size():
		return current_tasks[current_index]
	return null

# Función para completar la tarea actual
func complete_task(task_id: String) -> void:
	var current = get_current_task()
	
	if current and current.id == task_id and not current.is_completed:
		current.is_completed = true
		emit_signal("task_completed", task_id)
		print("¡Tarea completada con éxito: ", current.id, "!")
		
		# Avanzar al siguiente índice de la lista
		current_index += 1
		
		# Verificar si hay una nueva tarea o si ya terminaron todas
		var siguiente_tarea = get_current_task()
		if siguiente_tarea:
			emit_signal("task_updated", siguiente_tarea.description)
			print("Nueva tarea activa: ", siguiente_tarea.description)
		else:
			emit_signal("task_updated", "Turno finalizado / Todo completado")
			emit_signal("all_tasks_completed")
			print("¡Todas las tareas del listado fueron completadas!")
	else:
		print("ADVERTENCIA: Se intentó completar la tarea ID '", task_id, "', pero no coincide con la tarea activa actual.")
		
# Devuelve true si la tarea ya fue completada, o false si sigue pendiente
func is_task_completed(task_id: String) -> bool:
	# Buscamos la tarea en tu lista o diccionario de tareas
	# (Ajusta esta lógica según cómo guardes tus tareas internamente, por ejemplo: tasks[task_id].is_completed)
	
	for task in current_tasks: # O el nombre de la variable donde guardes tus tareas
		if task.id == task_id:
			return task.is_completed
			
	return false
