package ru.smr.stuff {
	public class Random {
		private static function getNextSeed(seed:int):int {
			if (seed <= 0)
				seed = Math.random() * int.MAX_VALUE;
			seed ^= seed << 13;
			seed ^= seed >> 17;
			seed ^= seed << 5;
			return seed > 0 ? seed : -seed;
		}

		public static function getRandom(seed:int):Number {
			var value:Number = getNextSeed(seed) / int.MAX_VALUE;
			return value > 0 ? value : -value;
		}

		private var _seed:int;

		public function Random(seed:int = 0) {
			_seed = seed;
		}

		public function getInt(min:int = 0, max:int = int.MAX_VALUE):int {
			if (max < int.MAX_VALUE)
				max++;
			return min + (max - min) * random;
		}

		public function get random():Number {
			seed = getNextSeed(seed);
			var value:Number = seed / int.MAX_VALUE;
			return value > 0 ? value : -value;
		}

		public function set seed(value:int):void {
			_seed = value;
		}

		public function get seed():int {
			return _seed;
		}
	}
}
