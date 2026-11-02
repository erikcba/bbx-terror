class_name TaskResource
extends Resource

@export var id: String = ""
@export var description: String = ""
@export var is_completed: bool = false
@export var triggers_paranormal_event: bool = false
@export var event_name: String = "" # Nombre del evento a disparar al completar
