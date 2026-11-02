extends CanvasLayer

@onready var task_label: Label = $TaskLabel

func _ready() -> void:
	# Nos conectamos a las señales del Autoload de forma segura
	if TaskManager.has_signal("task_updated"):
		TaskManager.task_updated.connect(_on_task_updated)
		TaskManager.task_completed.connect(_on_task_completed)
	
	# Forzamos una lectura inmediata de la tarea actual al arrancar
	actualizar_texto_inicial()

func actualizar_texto_inicial() -> void:
	var current_task = TaskManager.get_current_task()
	if current_task:
		task_label.text = "Tarea: " + current_task.description
		print("HUD: Tarea inicial cargada con éxito -> ", current_task.description)
	else:
		task_label.text = "Tarea: Ninguna tarea activa"
		print("HUD: No se encontró ninguna tarea activa en el TaskManager.")

func _on_task_updated(task_description: String) -> void:
	task_label.text = "Tarea: " + task_description

func _on_task_completed(task_id: String) -> void:
	print("HUD: Tarea completada detectada -> ", task_id)
