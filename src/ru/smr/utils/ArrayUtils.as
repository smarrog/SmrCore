package ru.smr.utils {
	import flash.utils.Dictionary;

	public class ArrayUtils {
		public static function vectorToArray(v:*):Array {
			var arr:Array = [];
			v.forEach(function (elem:Object, ...rest):void {
				arr.push(elem);
			});
			return arr;
		}

		public static function union(a:*, b:*):* {
			if (!a && !b) return null;
			if (!a) return b.concat();
			if (!b) return a.concat();
			var result:* = a.concat();
			b.forEach(function (elem:Object, ...rest):void {
				if (result.indexOf(elem) == -1)
					result.push(elem);
			});
			return result;
		}

		public static function unify(v:*):* {
			if (!v || !v.length)
				return v;

			var dict:Dictionary = new Dictionary();
			var copy:* = v.concat();
			v.length = 0;
			copy.forEach(function(elem:*, ...rest):void {
				if (dict[elem])
					return;
				dict[elem] = true;
				v.push(elem);
			});
			return v;
		}

		public static function shuffle(v:*):* {
			return v ? v.concat().map(function (...rest):* {
				return v.splice(int(Math.random() * v.length), 1).pop();
			}) : null;
		}

		public static function getRandomFields(v:*, count:int = 50):* {
			if (!v)
				return null;
			if (v.length <= count)
				return v;
			v = shuffle(v);
			v.length = 50;
			return v;
		}

		public static function foldLeft(s:*, l:*, f:Function):* {
			l.forEach(function (i:*, ..._):* {
				s = f(s, i);
			});
			return s;
		}

		public static function pushUnique(a:*, b:*):void {
			a.push.apply(null, AExceptB(b, a));
		}

		public static function isEqual(a:*, b:*):Boolean {
			if (!a && !b) return true;
			if (!a || !b) return false;
			if (a.length != b.length)
				return false;
			for (var i:int = 0; i < a.length; i++)
				if (a[i] !== b[i])
					return false;
			return true;
		}

		public static function AExceptB(a:*, b:*):* {
			if (!a) return null;
			if (!b) return a;
			return a.filter(function (elem:Object, index:int, ...params):Boolean {
				return b.indexOf(elem) == -1;
			});
		}
		
		public static function toObject(a:*):Object {
			var o:Object = {};
			for (var i:int = 0; i < a.length; i++)
				o[i] = a[i];
			return o;
		}
	}
}
