extends Node

const Minuttes_Per_Day: int = 24 * 60
const Minuttes_Per_Hour: int = 60
const Game_Minute_Duration: float = TAU / Minuttes_Per_Day

var Game_Speed: float = 1.0 

var Inittial_Day: int = 1
var Inittial_Hour: int = 24
var Inittial_Mintute: int = 60

var time: float = 0.0
var Current_minute: int = -1
var Current_day: int = 0

signal Game_time(time:float)
signal Time_tick(day: int, hour: int, minute: int)
signal Time_tick_day(day:int)

func _ready() -> void:
	set_initial_time()

func _process(delta: float) -> void:
	time += delta * Game_Speed * Game_Minute_Duration
	Game_time.emit(time)
	
	recalcullate_time()

func  set_initial_time() ->void:
	var initial_total_minutes = Inittial_Day * Minuttes_Per_Day + (Inittial_Hour * Minuttes_Per_Hour) + Inittial_Mintute
	
	time = initial_total_minutes * Game_Minute_Duration

func recalcullate_time() ->void:
	var total_minutes: int = int(time / Game_Minute_Duration)
	var day:int = int(total_minutes / Minuttes_Per_Day)
	var current_day_minutes:int = total_minutes % Minuttes_Per_Day
	var hour:int = int(current_day_minutes / Minuttes_Per_Hour)
	var minute:int = int(current_day_minutes % Minuttes_Per_Hour)
	
	if current_day_minutes != minute:
		Current_minute = minute
		Time_tick.emit(day, hour, minute)
	
	if Current_day != day:
		Current_day = day
		Time_tick_day.emit(day)
