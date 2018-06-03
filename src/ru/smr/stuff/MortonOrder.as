package ru.smr.stuff {
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class MortonOrder {
		public static function setBitAt(value:uint, index:int, bit:Boolean):uint {
			if (getBitAt(value, index) != bit)
				value |= (1 << index);
			return value;
		}

		public static function getBitAt(value:uint, index:int):Boolean {
			return (value & (1 << index)) > 0;
		}

		public static function encode(points:Vector.<Point>):ByteArray {
			var getByte:Function = function(index:int):int {
				while (data.length <= index)
					data.writeByte(0);
				data.position = index;
				return data.readByte();
			};
			
			var data:ByteArray = new ByteArray();
			points.forEach(function(point:Point, ...rest):void {
				var mortonIndex:uint = getIndex(point.x, point.y);
				var byteIndex:int = mortonIndex / 8;
				var b:int = setBitAt(getByte(byteIndex), mortonIndex % 8, true);
				data.position = byteIndex;
				data.writeByte(b);
			});
			data.compress();
			return data;
		}

		public static function decode(data:ByteArray):Vector.<Point> {
			data.position = 0;
			data.uncompress();
			var points:Vector.<Point> = new <Point>[];
			while (data.position < data.length) {
				var b:int = data.readByte();
				for (var i:int = 0; i < 8; ++i)
					if (getBitAt(b, i))
						points.push(getPoint((data.position - 1) * 8 + i));
			}
			return points;
		}
		
		public static function getPoint(index:uint):Point {
			return new Point(mortonEven(index), mortonEven(index >> 1));
		}

		public static function getIndex(x:uint, y:uint):uint {
		    x = (x | (x << 8)) & 0x00FF00FF;
		    x = (x | (x << 4)) & 0x0F0F0F0F;
		    x = (x | (x << 2)) & 0x33333333;
		    x = (x | (x << 1)) & 0x55555555;

		    y = (y | (y << 8)) & 0x00FF00FF;
		    y = (y | (y << 4)) & 0x0F0F0F0F;
		    y = (y | (y << 2)) & 0x33333333;
		    y = (y | (y << 1)) & 0x55555555;

		    return x | (y << 1);
		}

		private static function mortonEven(index:uint):uint { // extract even bits
		    index = index & 0x55555555;
		    index = (index | (index >> 1)) & 0x33333333;
		    index = (index | (index >> 2)) & 0x0F0F0F0F;
		    index = (index | (index >> 4)) & 0x00FF00FF;
		    index = (index | (index >> 8)) & 0x0000FFFF;
		    return index;
		}
	}
}