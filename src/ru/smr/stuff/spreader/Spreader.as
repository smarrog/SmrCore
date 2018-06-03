package ru.smr.stuff.spreader {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class Spreader {
		private static var _dispatcher:Sprite = new Sprite();
		private static var _workers:Vector.<Worker>;
		private static var _texts:Vector.<InfoText>;

		private static function addFrameListener():void {
			_dispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private static function removeFrameListener():void {
			if (_dispatcher) {
				_dispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private static function onEnterFrame(event:Event):void {
			_workers = _workers.filter(function (worker:Worker, ...params):Boolean {
				if (worker.isCompleted) {
					worker.parent.removeChild(worker);
					return false;
				}
				worker.update();
				return true;
			});
			_texts = _texts.filter(function (elem:InfoText, ...params):Boolean {
				if (elem.isCompleted) {
					elem.parent.removeChild(elem);
					return false;
				}
				elem.update();
				return true;
			});
			if (!_workers.length && !_texts.length) {
				removeFrameListener();
			}
		}

		private var _parent:DisplayObjectContainer;
		private var _x:Number;
		private var _y:Number;

		public function Spreader(parent:DisplayObjectContainer, x:Number = 0, y:Number = 0) {
			_workers ||= new <Worker>[];
			_texts ||= new <InfoText>[];
			_parent = parent;
			_x = x;
			_y = y;
		}

		public function spreadMany(data:Array, toX:Number, toY:Number, interval:int = 0, param:SpreaderParam = null):void {
			var timeout:int = 0;
			data.forEach(function (what:DisplayObject, ...params):void {
				setTimeout(function ():void {
					spread(what, toX, toY, null, param);
				}, timeout);
				timeout += interval;
			})
		}

		public function spread(what:DisplayObject, toX:Number, toY:Number, text:DisplayObject = null, param:SpreaderParam = null, textParam:InfoTextParam = null):void {
			param = param ? param : new SpreaderParam();
			var worker:Worker = new Worker(what, x, y, toX, toY, param, function ():void {
				if (!text)
					return;
				setTimeout(function ():void {
					var txt:InfoText = new InfoText(text, worker.x, worker.y, textParam);
					_parent.addChild(txt);
					_texts.push(txt);
				}, param.touchInterval);
			});
			_workers.push(worker);
			_parent.addChild(worker);
			addFrameListener();
		}

		public function move(x:Number, y:Number):void {
			_x = x;
			_y = y;
		}

		public function set parent(value:DisplayObjectContainer):void {
			_parent = value;
		}

		public function set x(value:Number):void {
			_x = value;
		}

		public function set y(value:Number):void {
			_y = value;
		}

		public function get parent():DisplayObjectContainer {
			return _parent;
		}

		public function get x():Number {
			return _x;
		}

		public function get y():Number {
			return _y;
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.setTimeout;

import ru.smr.stuff.spreader.SpreaderParam;

class Worker extends Sprite {
	private var _squeezeContainer:Sprite = new Sprite();
	private var _flyingAway:Boolean = false;
	private var _fallingDown:Boolean = false;
	private var _squeezing:Boolean;
	private var _timeInFly:int;
	private var _startX:Number;
	private var _startY:Number;
	private var _fallDownY:Number;
	private var _onTouch:Function;

	private var _flyTo:Point;
	private var _curPos:Point;
	private var _velocity:Point;

	private var _fallDownSpeedX:Number;
	private var _fallDownSpeedY:Number;

	public var param:SpreaderParam;

	public function Worker(content:DisplayObject, startX:Number, startY:Number, flyToX:Number, flyToY:Number, param:SpreaderParam, onTouch:Function) {
		this.param = param;
		_onTouch = onTouch;

		_flyTo = new Point(flyToX, flyToY);

		addChild(_squeezeContainer);
		_squeezeContainer.addChild(content);
		_squeezeContainer.y = content.height;
		content.y = -content.height;

		x = _startX = startX;
		y = _startY = startY;

		filters = [new DropShadowFilter(1, 90, 0x000000, 1, 3, 3, 1, 3)];

		scaleMe(param.needScale ? .2 : param.scale);

		if (param.isFallingDown) {
			fallDown();
		} else {
			flyAway();
		}
	}

	private function scaleMe(scaleValue:Number):void {
		scaleX = scaleValue;
		scaleY = scaleValue;
	}

	private function fallDown():void {
		if (_fallingDown)
			return;
		_fallingDown = true;
		var angle:Number = -Math.PI / 2 + (-param.fallDownAngle / 2 + Math.random() * param.fallDownAngle);
		var vel:Number = param.fallDownSpeed + Math.random() * param.fallDownSpeedVar;
		_fallDownSpeedX = vel * Math.cos(angle);
		_fallDownSpeedY = vel * Math.sin(angle);
		_fallDownY = y + param.fallDownMinY + Math.random() * (param.fallDownMaxY - param.fallDownMinY);
		fallIfNeed();
	}

	private function onFallDown():void {
		_fallingDown = false;
		_squeezing = param.squeezeMax < 1;
		squeezeIfNeed();
		addEventListener(MouseEvent.ROLL_OVER, onTouch);
		setTimeout(flyAway, param.flyAfter + (-param.flyAfterVar + Math.random() * param.flyAfterVar));
	}

	private function flyAway():void {
		if (_flyingAway)
			return;
		_timeInFly = 0;
		_flyingAway = true;
		_curPos = new Point(x, y);
		var dirFrom:Point = _curPos.subtract(_flyTo);
		dirFrom.normalize(param.flyAwaySpeed + param.flyAwaySpeedVar * Math.random());
		var mat:Matrix = new Matrix();
		mat.rotate(-param.flyAwayAngle / 2 + param.flyAwayAngle * Math.random());
		_velocity = mat.transformPoint(dirFrom);
		removeEventListener(MouseEvent.ROLL_OVER, onTouch);
		flyIfNeed();
	}

	private function squeezeIfNeed():void {
		if (_squeezing) {
			_squeezeContainer.scaleY = Math.max(param.squeezeMax, _squeezeContainer.scaleY - param.squeezeModif);
			if (_squeezeContainer.scaleY == param.squeezeMax) {
				_squeezing = false;
			}
		} else if (_squeezeContainer.scaleY < 1) {
			_squeezeContainer.scaleY = Math.min(_squeezeContainer.scaleY + param.squeezeModif);
		}
	}

	private function fallIfNeed():void {
		if (!_fallingDown)
			return;
		x += _fallDownSpeedX;
		_fallDownSpeedY += param.fallDownAcceleration;
		y += _fallDownSpeedY;
		if (y >= _fallDownY && _fallDownSpeedY > 0) {
			onFallDown();
		}
	}

	private function flyIfNeed():void {
		if (!_flyingAway)
			return;
		_curPos.x = x;
		_curPos.y = y;
		var dirTo:Point = _flyTo.subtract(_curPos);
		dirTo.normalize(param.flyAwayAcceleration);
		_velocity = _velocity.add(dirTo);
		_velocity.x *= param.flyAwayBreak;
		_velocity.y *= param.flyAwayBreak;
		_curPos = _curPos.add(_velocity);
		x = _curPos.x;
		y = _curPos.y;
	}

	private function onTouch(event:MouseEvent):void {
		_onTouch();
		flyAway();
	}

	public function update():void {
		if (param.needScale && scaleX < param.scale) {
			scaleMe(Math.min(param.scale, scaleX + .05));
		}
		squeezeIfNeed();
		flyIfNeed();
		fallIfNeed();
	}

	public function get isCompleted():Boolean {
		return _flyingAway && (Point.distance(_curPos, _flyTo) < _velocity.length);
	}
}