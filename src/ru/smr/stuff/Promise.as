package ru.smr.stuff {
	import flash.display.Sprite;
	import flash.events.Event;

	public class Promise {
		private static const WAITING:String = "waiting";
		private static const RESOLVED:String = "resolved";
		private static const REJECTED:String = "rejected";

		private static const _dispatcher:Sprite = new Sprite();

		public static function resolve(value:*):Promise {
			return new Promise().resolve(value);
		}

		public static function reject(value:*):Promise {
			return new Promise().reject(value);
		}

		private var _value:*;
		private var _status:String = WAITING;
		private var _handlers:Vector.<Handler> = new <Handler>[];

		public function Promise() {

		}

		public function resolve(value:*):Promise {
			return complete(value, RESOLVED);
		}

		public function reject(value:*):Promise {
			return complete(value, REJECTED);
		}

		public function then(onResolved:Function, onRejected:Function = null):Promise {
			registerHandler(onResolved, RESOLVED);
			registerHandler(onRejected, REJECTED);
			return this;
		}

		public function otherwise(onRejected:Function):Promise {
			registerHandler(onRejected, REJECTED);
			return this;
		}

		public function always(onCompleted:Function):Promise {
			registerHandler(onCompleted);
			return this;
		}

		public function reset():Promise {
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			_handlers.length = 0;
			_value = null;
			_status = WAITING;
			return this;
		}

		public function get isCompleted():Boolean {
			return _status != WAITING;
		}

		private function registerHandler(handler:Function, requiredStatus:String = null):void {
			if (handler == null)
				return;
			_handlers.push(new Handler(handler, requiredStatus));
			callHandlersOnNextFrame();
		}

		private function complete(value:*, status:String):Promise {
			if (isCompleted)
				return this;
			_value = value;
			_status = status;
			callHandlersOnNextFrame();
			return this;
		}

		private function callHandlersOnNextFrame():void {
			if (!isCompleted)
				return;
			_dispatcher.addEventListener(Event.ENTER_FRAME, onNextFrame);
		}

		private function onNextFrame(event:Event):void {
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onNextFrame);
			var handlers:Vector.<Handler> = _handlers.concat();
			_handlers.length = 0;
			handlers.forEach(function(handler:Handler, ...rest):void {
				handler.callIfNeed(_status, _value);
			});
		}
	}
}

class Handler {
	private var _handler:Function;
	private var _requiredStatus:String;

	public function Handler(handler:Function, requiredStatus:String = null) {
		_handler = handler;
		_requiredStatus = requiredStatus;
	}

	public function callIfNeed(status:String, value:*):void {
		if (_requiredStatus != null && _requiredStatus != status)
			return;
		if (_handler.length > 0)
			_handler(value);
		else
			_handler();
	}
}
