package ru.smr.utils {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class CommonUtils {
		public static function getClassOf(target:Object):Class {
			return getDefinitionByName(getQualifiedClassName(target)) as Class;
		}

		public static function isOfClass(target:Object, cl:Class):Boolean {
			return cl == getClassOf(target);
		}

		public static function getParamsFromURL(url:String):Object {
			var urlVars:Object = {};
			var query:Array = url.match(/(?<=\?).+$/);
			for each(var s:String in query[0].split("&")) {
				var pairSplit:Array = s.split("=");
				urlVars[pairSplit[0]] = pairSplit[1];
			}
			return urlVars;
		}

		public static function toPrecision(number:Number, precision:int):Number {
			if (precision < 0)
				return number;
			var strValue:String = number.toString();
			if (strValue.length <= precision + 2)
				return number;
			precision = Math.pow(10, precision);
			return Math.round(number * precision) / precision;
		}

		public static function isEmptyObject(obj:Object):Boolean {
			for (var key:String in obj)
				return false;
			return true;
		}
	}
}
