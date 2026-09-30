extends Resource
class_name KinematicMovement


static func calculate_movement(
	context: KinematicContext,
	speed_modifiers: Array[Callable],
	direction_modifiers: Array[Callable],
	velocity_modifiers: Array[Callable],
	rotation_modifiers: Array[Callable],
	rotation_source: Callable = face_velocity,
) -> KinematicSteeringOutput:

	var direction = direction_pipeline(
		context.direction,
		context,
		direction_modifiers
	)

	var speed = speed_pipeline(
		context.max_speed,
		context,
		speed_modifiers
	)

	var desired_velocity = direction * speed
	
	var velocity = velocity_pipeline(
		desired_velocity,
		context,
		velocity_modifiers
	)

	var rotation = rotation_pipeline(
		rotation_source.call(velocity, context),
		context,
		rotation_modifiers
	)

	return KinematicSteeringOutput.new(
		velocity,
		rotation
	)


static func speed_pipeline(
	speed: float,
	context: KinematicContext,
	modifiers: Array[Callable]
) -> float:
	for modifier in modifiers:
		speed = modifier.call(speed, context)

	return speed
	
static func direction_pipeline(
	direction: Vector2,
	context: KinematicContext,
	modifiers: Array[Callable]
) -> Vector2:
	for modifier in modifiers:
		direction = modifier.call(direction, context)

	return direction
	
static func velocity_pipeline(
	velocity: Vector2,
	context: KinematicContext,
	modifiers: Array[Callable]
) -> Vector2:
	for modifier in modifiers:
		velocity = modifier.call(velocity, context)

	return velocity

static func rotation_pipeline(
	rotation: float,
	context: KinematicContext,
	modifiers: Array[Callable]
) -> float:
	for modifier in modifiers:
		rotation = modifier.call(rotation, context)

	return rotation


static func seek(context: KinematicContext) -> KinematicSteeringOutput:
	return calculate_movement(context, [], [], [limit_velocity_change], [smooth_rotation])


static func arrive(context: KinematicContext) -> KinematicSteeringOutput:
	return calculate_movement(context, [slow_down, stop_at_radius], [], [limit_velocity_change], [smooth_rotation])


static func flee(context: KinematicContext) -> KinematicSteeringOutput:
	return calculate_movement(context, [], [away_from_target], [limit_velocity_change], [smooth_rotation])


static func wander(context: KinematicContext) -> KinematicSteeringOutput:
	return calculate_movement(context, [slow_down, stop_at_radius], [wandering_direction], [limit_velocity_change], [smooth_rotation])


static func wandering_direction(direction: Vector2, _context: KinematicContext) -> Vector2:
	var max_spread_deg := 180.0
	var max_spread_rad := deg_to_rad(max_spread_deg)

	var mean := 0.0
	var deviation := max_spread_rad / 3.0
	var random_angle := randfn(mean, deviation)
	return direction.rotated(random_angle)


static func away_from_target(direction: Vector2, _context: KinematicContext) -> Vector2:
	return -direction


static func limit_velocity_change(desired_velocity: Vector2, context: KinematicContext) -> Vector2:
	return context.velocity + (desired_velocity - context.velocity).limit_length(context.max_force)

static func slow_down(speed: float, context: KinematicContext) -> float:
	var distance = context.distance
	var slowing_radius = context.slowing_radius
	if distance < slowing_radius:
		speed *= distance / slowing_radius
		return speed
		
	return speed
	
	
static func stop_at_radius(speed: float, context: KinematicContext) -> float:
	if context.distance < context.stop_radius:
		return 0
	return speed
	
static func face_velocity(velocity: Vector2, context: KinematicContext) -> float:
	if velocity.length_squared() < 2.0:
		return context.rotation
	return velocity.angle()  - PI / 2

static func smooth_rotation(rotation: float, context: KinematicContext) -> float:
	var target_angle := rotation
	return lerp_angle(context.rotation, target_angle, 0.1)
