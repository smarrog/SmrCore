package ru.smr.stuff.iso {
	import flash.geom.Point;

	public class IsoPoint extends Point {
		public static function fromPoint(point:Point):IsoPoint {
			return new IsoPoint(point.x, point.y);
		}
		
		public var z:Number = 0;

		public function IsoPoint(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.z = z;
			super(x, y);
		}

		public override function get length():Number {
			return Math.sqrt(x * x + y * y + z * z);
		}

		public override function clone():Point {
			return new IsoPoint(x, y, z);
		}

		public override function toString():String {
			return "x:" + x + " y:" + y + " z:" + z;
		}

		public function copyFromIsoPoint(point:IsoPoint):void {
			x = point.x;
			y = point.y;
			z = point.z;
		}

		public function equalsPt(toCompare:IsoPoint):Boolean {
			return ((toCompare.x == x) && (toCompare.y == y) && (toCompare.z == z));
		}

		public function normalizeAsGridCell(factor:Number):IsoPoint {
			x = Math.floor(x / factor);
			y = Math.floor(y / factor);
			z = Math.floor(z / factor);
			return this;
		}

		public function clonePt():IsoPoint {
			return new IsoPoint(x, y, z);
		}

		public function multiply(factor:Number):IsoPoint {
			x *= factor;
			y *= factor;
			z *= factor;
			return this;
		}

		public function offsetPt(dx:Number = 0, dy:Number = 0, dz:Number = 0):IsoPoint {
			x += dx;
			y += dy;
			z += dz;
			return this;
		}

		public function addPt(target:IsoPoint):IsoPoint {
			return offsetPt(target.x, target.y, target.z);
		}

		public function subtractPt(target:IsoPoint):IsoPoint {
			return offsetPt(-target.x, -target.y, -target.z);
		}
	}
}
