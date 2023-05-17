class_name LocalTime
## A class for local time.
##
## [b]Note:[/b] Not compatible with DST.
## [codeblock]
## # Create object
## var t = LocalTime.now()
## # Setter / Getter
## t.day = 15
## print(t.month)
## # Add time
## t.add_days(100)
## t.hour += 48
## # Format
## print(t.format("{lweekday}, {month}/{day}/{year}"))
## [/codeblock]


#-------------------------------------------------------------------------------
# Static variables
# Waiting for Godot 4.1
#-------------------------------------------------------------------------------
## An array of long month names.
var long_month_names: Array = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"]

## An array of short month names.
var short_month_names: Array = [
	"Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.",
	"Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."]

## An array of long weekday names.
var long_weekday_names: Array = [
	"Sunday", "Monday", "Tuesday", "Wednesday",
	"Thursday", "Friday", "Saturday"]

## An array of short weekday names.
var short_weekday_names: Array = [
	"Sun.", "Mon.", "Tue.", "Wed.",
	"Thu.", "Fri.", "Sat."]


#-------------------------------------------------------------------------------
# Static functions
#-------------------------------------------------------------------------------
## Returns the current Unix timestamp(UTC) in seconds.
static func get_system_time_secs() -> int:
	return int(Time.get_unix_time_from_system())


## Returns the current Unix timestamp(UTC) in milliseconds.
static func get_system_time_msecs() -> int:
	return int(Time.get_unix_time_from_system() * 1000.0)


## Returns true if the year is a leap year.
static func is_leap_year(year: int) -> bool:
	var dt0 = {"year":year, "month":2, "day":28, "hour":0, "minute":0, "second":0}
	var ut0 = Time.get_unix_time_from_datetime_dict(dt0)

	var ut1 = ut0 + 24*60*60
	var dt1 = Time.get_datetime_dict_from_unix_time(ut1)

	if dt1.day == 29:
		return true
	else:
		return false


## Returns true if the date is valid.
static func is_valid_date(date: Dictionary) -> bool:
	match date.month:
		1,3,5,7,8,10,12:
			if date.day < 1 or 31 < date.day:
				return false
			else:
				return true

		4,6,9,11:
			if date.day < 1 or 30 < date.day:
				return false
			else:
				return true

		2:
			if date.day == 29 and is_leap_year(date.year):
				return true
			if date.day < 1 or 28 < date.day:
				return false
			else:
				return true

		_:
			return false


#-------------------------------------------------------------------------------
# Main variables
#-------------------------------------------------------------------------------
## The Unix timestamp in UTC.
var utc_unix_time: int = 0

## A dictionary of the time zone.[br]
## [b]Note:[/b] See also [method Time.get_time_zone_from_system].
var time_zone: Dictionary = {}


#-------------------------------------------------------------------------------
# Main properties
#-------------------------------------------------------------------------------
## Year (local time). Only valid dates can be set.
var year: int:
	set(value):
		var dt = get_local_datetime()
		dt.year = value
		if set_local_datetime(dt) != OK:
			push_error("%04d-%02d-%02d is invalid." % [dt.year, dt.month, dt.day])
	get:
		return get_local_datetime().year


## Month (local time). Only valid dates can be set.
var month: int:
	set(value):
		var dt = get_local_datetime()
		dt.month = value
		if set_local_datetime(dt) != OK:
			push_error("%04d-%02d-%02d is invalid." % [dt.year, dt.month, dt.day])
	get:
		return get_local_datetime().month


## Day (local time). Only valid dates can be set.
var day: int:
	set(value):
		var dt = get_local_datetime()
		dt.day = value
		if set_local_datetime(dt) != OK:
			push_error("%04d-%02d-%02d is invalid." % [dt.year, dt.month, dt.day])
	get:
		return get_local_datetime().day


## Weekday (local time). This property is readonly.
var weekday: int:
	get:
		return get_local_datetime().weekday


## Hour (local time). Any integer value can be set.
var hour: int:
	set(value):
		var dt = get_local_datetime()
		dt.hour = value
		set_local_datetime(dt)
	get:
		return get_local_datetime().hour


## Minute (local time). Any integer value can be set.
var minute: int:
	set(value):
		var dt = get_local_datetime()
		dt.minute = value
		set_local_datetime(dt)
	get:
		return get_local_datetime().minute


## Second (local time). Any integer value can be set.
var second: int:
	set(value):
		var dt = get_local_datetime()
		dt.second = value
		set_local_datetime(dt)
	get:
		return get_local_datetime().second


#-------------------------------------------------------------------------------
# Sub properties
#-------------------------------------------------------------------------------
## Returns a string of long month name. This property is readonly.
var lmonth: String:
	get:
		return long_month_names[get_local_datetime().month - 1]


## Returns a string of short month name. This property is readonly.
var smonth: String:
	get:
		return short_month_names[get_local_datetime().month - 1]


## Returns a string of long weekday name. This property is readonly.
var lweekday: String:
	get:
		return long_weekday_names[get_local_datetime().weekday]


## Returns a string of short weekday name. This property is readonly.
var sweekday: String:
	get:
		return short_weekday_names[get_local_datetime().weekday]


#-------------------------------------------------------------------------------
# Constructors
#-------------------------------------------------------------------------------
## Initialize the object with new_utc_unix_time and new_time_zone.
func _init(new_utc_unix_time: int = 0, new_time_zone: Dictionary = {}) -> void:
	utc_unix_time = new_utc_unix_time

	if new_time_zone == {}:
		time_zone = Time.get_time_zone_from_system()
	else:
		time_zone = new_time_zone


## Initialize the object with the current time and new_time_zone.
static func now(new_time_zone: Dictionary = {}) -> LocalTime:
	return LocalTime.new(get_system_time_secs(), new_time_zone)


#-------------------------------------------------------------------------------
# Methods for set datetime
#-------------------------------------------------------------------------------
func _set_datetime(datetime: Dictionary, utc: bool = false) -> Error:
	if not LocalTime.is_valid_date(datetime):
		return FAILED

	var date000 = datetime.duplicate()
	date000.hour = 0
	date000.minute = 0
	date000.second = 0

	var tz = 0 if utc else time_zone.bias * 60
	utc_unix_time = Time.get_unix_time_from_datetime_dict(date000) - tz
	utc_unix_time += datetime.hour * 60 * 60
	utc_unix_time += datetime.minute * 60
	utc_unix_time += datetime.second

	return OK


## Returns [constant OK] if the datetime(local) were successfully set.
func set_local_datetime(datetime: Dictionary) -> Error:
	return _set_datetime(datetime, false)


## Returns [constant OK] if the datetime(utc) were successfully set.
func set_utc_datetime(datetime: Dictionary) -> Error:
	return _set_datetime(datetime, true)


#-------------------------------------------------------------------------------
# Methods for get datetime
#-------------------------------------------------------------------------------
func _get_datetime(utc: bool = false) -> Dictionary:
	var tz = 0 if utc else time_zone.bias * 60
	return Time.get_datetime_dict_from_unix_time(utc_unix_time + tz)


## Returns a dictionary of the datetime(local).
func get_local_datetime() -> Dictionary:
	return _get_datetime(false)


## Returns a dictionary of the datetime(utc).
func get_utc_datetime() -> Dictionary:
	return _get_datetime(true)


#-------------------------------------------------------------------------------
# Methods for add time
#-------------------------------------------------------------------------------
## Add time.
func add(
		seconds: int = 0, minutes: int = 0, hours: int = 0,
		days: int = 0, weeks: int = 0) -> void:
	utc_unix_time += seconds
	utc_unix_time += 60 * minutes
	utc_unix_time += 60 * 60 * hours
	utc_unix_time += 60 * 60 * 24 * days
	utc_unix_time += 60 * 60 * 24 * 7 * weeks


## Add seconds.
func add_seconds(seconds: int) -> void:
	add(seconds, 0, 0, 0, 0)


## Add minutes.
func add_minutes(minutes: int) -> void:
	add(0, minutes, 0, 0, 0)


## Add hours.
func add_hours(hours: int) -> void:
	add(0, 0, hours, 0, 0)


## Add days.
func add_days(days: int) -> void:
	add(0, 0, 0, days, 0)


## Add weeks.
func add_weeks(weeks: int) -> void:
	add(0, 0, 0, 0, weeks)


#-------------------------------------------------------------------------------
# Method for format
#-------------------------------------------------------------------------------
## Returns a format string of the pattern.
## [codeblock]
## var t = LocalTime.now()
## print(t.format("{lweekday}, {month}/{day}/{year}"))
## > Thursday, 5/18/2023
## [/codeblock][br]
## Available patterns:
## [codeblock]
## {year} {year:4d} {year:04d}
## {month} {month:2d} {month:02d} {lmonth} {smonth}
## {day} {day:2d} {day:02d}
## {weekday} {lweekday} {sweekday}
## {hour} {hour:2d} {hour:02d}
## {minute} {minute:2d} {minute:02d}
## {second} {second:2d} {second:02d}
## [/codeblock]
func format(pattern: String) -> String:
	var values = {}

	values["year"] = "%d" % year
	values["year:4d"] = "%4d" % year
	values["year:04d"] = "%04d" % year

	values["month"] = "%d" % month
	values["month:2d"] = "%2d" % month
	values["month:02d"] = "%02d" % month
	values["lmonth"] = "%s" % lmonth
	values["smonth"] = "%s" % smonth

	values["day"] = "%d" % day
	values["day:2d"] = "%2d" % day
	values["day:02d"] = "%02d" % day

	values["weekday"] = "%d" % weekday
	values["lweekday"] = "%s" % lweekday
	values["sweekday"] = "%s" % sweekday

	values["hour"] = "%d" % hour
	values["hour:2d"] = "%2d" % hour
	values["hour:02d"] = "%02d" % hour

	values["minute"] = "%d" % minute
	values["minute:2d"] = "%2d" % minute
	values["minute:02d"] = "%02d" % minute

	values["second"] = "%d" % second
	values["second:2d"] = "%2d" % second
	values["second:02d"] = "%02d" % second

	return pattern.format(values)
