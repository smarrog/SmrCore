package ru.smr.stuff.spreader {
	public class SpreaderParam {
		public var flyAfter:int = 6000;
		public var flyAfterVar:int = 2000;
		public var squeezeModif:Number = .05;
		public var squeezeMax:Number = .9;
		public var fallDownAngle:Number = Math.PI / 4;
		public var fallDownSpeed:int = 20;
		public var fallDownSpeedVar:int = 2;
		public var fallDownAcceleration:int = 6;
		public var flyAwayAngle:Number = Math.PI / 3 * 2;
		public var flyAwaySpeed:Number = 30;
		public var flyAwaySpeedVar:Number = 2;
		public var flyAwayAcceleration:Number = 10;
		public var flyAwayBreak:Number = .9;
		public var scale:Number = 1;
		public var needScale:Boolean = true;
		public var isFallingDown:Boolean = true;

		public var touchInterval:int = 100;

		private var _fallDownMinY:Number = 0;
		private var _fallDownMaxY:Number = 30;

		public function set fallDownMinY(value:Number):void {
			_fallDownMinY = Math.max(0, value);
		}

		public function set fallDownMaxY(value:Number):void {
			_fallDownMaxY = Math.max(0, value);
		}

		public function get fallDownMinY():Number {
			return Math.min(_fallDownMinY, _fallDownMaxY);
		}

		public function get fallDownMaxY():Number {
			return Math.max(_fallDownMinY, _fallDownMaxY);
		}
	}
}