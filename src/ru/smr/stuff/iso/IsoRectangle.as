package ru.smr.stuff.iso {
	import flash.geom.Rectangle;

	public class IsoRectangle extends Rectangle {
		public var z:Number;
		public var zSize:Number;

		public function IsoRectangle(x:Number = 0, y:Number = 0, z:Number = 0, width:Number = 0, length:Number = 0, zSize:Number = 0) {
			this.z = z;
			this.zSize = zSize;
			super(x, y, width, length);
		}

		public function multiply(value:Number):void {
			x *= value;
			y *= value;
			z *= value;
			width *= value;
			height *= value;
			zSize *= value;
		}

		public function set length(value:Number):void {
			height = value;
		}

		public function get length():Number {
			return height;
		}
	}
}
