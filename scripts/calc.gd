class_name Calc

static func jump_gravity(height: float, duration: float) -> float:
	return 8.*(height/pow(duration, 2.))

static func jump_velocity(height: float, gravity: float) -> float:
	return sqrt(2.*gravity*height)
