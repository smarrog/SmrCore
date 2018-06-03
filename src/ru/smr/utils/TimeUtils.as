package ru.smr.utils {
	public class TimeUtils {
		{
			setPostfix(SECOND, "s");
			setPostfix(MINUTE, "m");
			setPostfix(HOUR, "h");
			setPostfix(DAY, "d");
		}

		public static const SECOND:String = "second";
		public static const MINUTE:String = "minute";
		public static const HOUR:String = "hour";
		public static const DAY:String = "day";

		public static const SECONDS_IN_MINUTE:int = 60;
		public static const SECONDS_IN_HOUR:int = 3600;
		public static const SECONDS_IN_DAY:int = 86400;
		public static const MINUTES_IN_HOUR:int = 60;
		public static const HOURS_IN_DAY:int = 24;

		private static const INTERVALS_ORDER:Array = [DAY, HOUR, MINUTE, SECOND];
		private static const DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		private static var _timeValue:TimeValue;
		private static var _postfixes:Object = {};

		public static function get timeValue():TimeValue {
			_timeValue ||= new TimeValue(0);
			return _timeValue;
		}

		public static function setPostfix(interval:String, postfix:String):void {
			_postfixes[interval] = postfix;
		}

		public static function getNextIntervalTime(interval:String, time:int, offset:int):int {
			return trimTime(time + offset, interval) + getIntervalInSeconds(interval) - offset;
		}

		public static function trimTime(timeInSeconds:int, timeInterval:String):int {
			var date:Date = new Date(timeInSeconds * 1000);
			switch (timeInterval) {
				case MINUTE:
					return date.setUTCSeconds(0) / 1000;
				case HOUR:
					return date.setUTCMinutes(0, 0) / 1000;
				case DAY:
					return date.setUTCHours(0, 0, 0) / 1000;
				default:
					return date.time / 1000;
			}
		}

		public static function getIntervalInSeconds(timeInterval:String, times:int = 1):int {
			switch (timeInterval) {
				case SECOND:
					return times;
				case MINUTE:
					return times * SECONDS_IN_MINUTE;
				case HOUR:
					return times * SECONDS_IN_HOUR;
				case DAY:
					return times * SECONDS_IN_DAY;
				default:
					return 0;
			}
		}

		public static function date2string(value:int, dayIsFirst:Boolean = true):String {
			var date:Date = new Date(value * 1000);
			var d:String = intToLimitDigitString(date.getDate(), 2);
			var m:String = intToLimitDigitString((date.getMonth() + 1), 2);
			var y:String = date.getFullYear().toString();
			var first:String = dayIsFirst ? d : m;
			var second:String = dayIsFirst ? m : d;
			return first + "." + second + "." + y;
		}

		public static function time2string(value:int, maxIntervals:int = 2):String {
			timeValue.value = value;
			var str:String = "";
			var found:int = 0;
			INTERVALS_ORDER.forEach(function (interval:String, i:int, ...rest):void {
				if (found == maxIntervals)
					return;

				var intervalValue:int = timeValue.getIntervalTimes(interval);
				if (intervalValue == 0) {
					if (found > 0) {
						found++;
					}
					return;
				}

				if (found > 0) {
					str += " ";
				}
				str += timeValue.getIntervalTimes(interval);
				if (_postfixes.hasOwnProperty(interval)) {
					str += " " + _postfixes[interval];
				}
				found++;
			});
			return str;
		}

		public static function get daysInCurrentMonth():int {
			return getDaysInMonth(new Date().time / 1000);
		}

		public static function getDaysInMonth(time:int):int {
			var date:Date = new Date(time * 1000);
			var daysInMonth:int = DAYS_IN_MONTH[date.month];
			if (date.month == 1 && (date.fullYear % 4) == 0)
				daysInMonth++;
			return daysInMonth;
		}

		private static function intToLimitDigitString(value:int, digits:int):String {
			var str:String = value.toString();
			while (str.length < digits) {
				str = "0" + str;
			}
			return str;
		}
	}
}

import flash.utils.Dictionary;

import ru.smr.utils.TimeUtils;

class TimeValue {
	private var _value:int;
	private var _values:Dictionary = new Dictionary();

	public function TimeValue(value:int):void {
		this.value = value;
	}

	public function set value(v:int):void {
		if (v < 0) v = 0;
		if (_value == v)
			return;

		_value = v;
		_values = new Dictionary();
	}

	public function get value():int {
		return _value;
	}

	public function getIntervalTimes(interval:String):int {
		if (!_values.hasOwnProperty(interval)) {
			var value:int = 0;
			switch (interval) {
				case TimeUtils.DAY:
					value = _value / TimeUtils.SECONDS_IN_DAY;
					break;
				case TimeUtils.HOUR:
					value = _value / TimeUtils.SECONDS_IN_HOUR % TimeUtils.HOURS_IN_DAY;
					break;
				case TimeUtils.MINUTE:
					value = _value / TimeUtils.SECONDS_IN_MINUTE % TimeUtils.MINUTES_IN_HOUR;
					break;
				case TimeUtils.SECOND:
					value = _value % TimeUtils.SECONDS_IN_MINUTE;
					break;
			}
			_values[interval] = value;
		}
		return _values[interval];
	}
}
