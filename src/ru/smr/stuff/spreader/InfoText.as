package ru.smr.stuff.spreader {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class InfoText extends Sprite {
		private var _appearing:Boolean;
		private var _scaleUp:Boolean;
		private var _moving:Boolean;
		private var _hiding:Boolean;
		private var _startX:Number;
		private var _startY:Number;
		private var _realX:Number; // in case if value is rounded by getter "x"
		private var _realY:Number; // in case if value is rounded by getter "y"

		private var _isCompleted:Boolean;
		private var _param:InfoTextParam;

		public function InfoText(obj:DisplayObject, x:Number, y:Number, param:InfoTextParam) {
			mouseEnabled = mouseChildren = false;
			init(obj, x, y, param);
		}

		private function appear():void {
			_appearing = true;
			_scaleUp = true;
			scaleX = scaleY = 0;
		}

		private function appearIfNeeded():void {
			scaleX = _scaleUp ? Math.min(_param.maxScale, scaleX + _param.scaleSpeed) : Math.max(1, scaleX - _param.scaleSpeed);
			scaleY = _scaleUp ? Math.min(_param.maxScale, scaleY + _param.scaleSpeed) : Math.max(1, scaleY - _param.scaleSpeed);
			if (scaleX == _param.maxScale)
				_scaleUp = false;
			else if (!_scaleUp && (scaleX == 1)) {
				_appearing = false;
				_moving = true;
			}
		}

		private function moveIfNeeded():void {
			y = Math.max(_startY - _param.moveDistance, y - _param.moveSpeed);
			if (y != _startY - _param.moveDistance)
				return;
			_moving = false;
			_hiding = true;
		}

		private function hideIfNeeded():void {
			if (!_hiding)
				return;
			alpha = Math.max(0, alpha - _param.alphaSpeed);
			if (alpha == 0)
				_isCompleted = true;
		}

		public override function set x(value:Number):void {
			_realX = value;
			super.x = value;
		}

		public override function set y(value:Number):void {
			_realY = value;
			super.y = value;
		}

		public override function get x():Number {
			return _realX;
		}

		public override function get y():Number {
			return _realY;
		}

		public function init(obj:DisplayObject, x:Number, y:Number, param:InfoTextParam = null):void {
			_startX = x;
			_startY = y;
			this.x = x;
			this.y = y;
			alpha = 1;
			_appearing = _moving = _hiding = _scaleUp = _isCompleted = false;
			this._param = param ? param : new InfoTextParam();
			addChild(obj);
			appear();
		}

		public function update():void {
			appearIfNeeded();
			moveIfNeeded();
			hideIfNeeded();
		}

		public function get isCompleted():Boolean {
			return _isCompleted;
		}
	}
}