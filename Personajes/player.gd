extends CharacterBody3D

const SPEED = 3
const JUMP_VELOCITY = 4.5

# Asegúrate de tener referenciado tu RayCast3D aquí arriba
@onready var interaction_ray: RayCast3D = $cabeza/Camera3D/RayCast3D
@onready var prompt_label: Label = get_node("../Control/PromptLabel")
@onready var footstep_player: AudioStreamPlayer3D = $FootstepsPlayer
@onready var linterna: SpotLight3D = $cabeza/Camera3D/Linterna

var step_timer: float = 0.0
var can_move: bool = true
@export var step_interval: float = 0.4

func _physics_process(delta: float) -> void:
	# La gravedad siempre actúa para que no flote si lo bloqueas en el aire
	if not is_on_floor():
		velocity += get_gravity() * delta

	# SI PUEDE MOVERSE: procesamos entradas normales
	if can_move:
		# Salto
		if Input.is_action_just_pressed("saltar") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Movimiento
		var input_dir := Input.get_vector("izquierda", "derecha", "adelante", "atras")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		# Lógica de pasos
		gestionar_pasos(direction)
	else:
		# SI ESTÁ BLOQUEADO: frenamos suavemente al personaje y cortamos el sonido de pasos
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		footstep_player.stop()

	move_and_slide()
	verificar_interaccion_visual()

# Función para bloquear el movimiento durante 'X' segundos
func bloquear_movimiento(tiempo: float) -> void:
	can_move = false
	# Espera los segundos indicados de forma asíncrona sin congelar el juego
	await get_tree().create_timer(tiempo).timeout
	can_move = true

# NUEVO: Bloquea el movimiento del mouse (cámara) cuando el personaje está detenido/bloqueado
func _input(event: InputEvent) -> void:

	
	if not can_move and event is InputEventMouseMotion:
		# Al consumir el evento o evitar que rote, la cámara se queda fija
		get_viewport().set_input_as_handled()

func gestionar_pasos(direction: Vector3) -> void:
	# Verificamos si nos estamos moviendo y estamos tocando el suelo
	if direction != Vector3.ZERO and is_on_floor():
		# Si el audio no se está reproduciendo actualmente, lo iniciamos
		if not footstep_player.playing:
			footstep_player.play()
	else:
		# Si nos detenemos o saltamos, detenemos el audio de inmediato
		footstep_player.stop()

func verificar_interaccion_visual() -> void:
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		# Verificamos si el objeto tiene la propiedad 'prompt_mensaje'
		if collider and "prompt_mensaje" in collider:
			prompt_label.text = collider.prompt_mensaje
			return
			
	# Si no choca con nada o el objeto no es interactivo, limpiamos el texto
	prompt_label.text = ""

# Usamos _unhandled_input para detectar la tecla de interacción de forma limpia
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("linterna"):
		# Alternamos la visibilidad (si está encendida se apaga, y viceversa)
		linterna.visible = not linterna.visible
		
		# Opcional: Reproducir un sonidito de chasquido de interruptor si lo tienes
		# if click_linterna_player:
		#     click_linterna_player.play()
		
		print("Linterna state: ", linterna.visible)
	
	if event.is_action_pressed("interact") and can_move:
		if interaction_ray.is_colliding():
			var collider = interaction_ray.get_collider()
			if collider and collider.has_method("interact"):
				
				# Por defecto, si el objeto no especifica tiempo, bloqueamos 0.0 segundos (instantáneo)
				var tiempo_a_bloquear: float = 0.0 
				
				# Si el objeto tiene la variable 'tiempo_bloqueo', usamos ese valor
				if "tiempo_bloqueo" in collider:
					tiempo_a_bloquear = collider.tiempo_bloqueo
				
				# Bloqueamos el movimiento solo el tiempo que diga este objeto en particular
				if tiempo_a_bloquear > 0.0:
					bloquear_movimiento(tiempo_a_bloquear)
					
				# Ejecutamos la acción del objeto
				collider.interact()
