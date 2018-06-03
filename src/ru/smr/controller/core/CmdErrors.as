package ru.smr.controller.core {
	public class CmdErrors {
		private var _unhandledErrors:Vector.<CmdError> = new <CmdError>[];
		private var _handledErrors:Vector.<ErrorWithHandler> = new <ErrorWithHandler>[];

		public function CmdErrors() {
		}

		public function addError(error:CmdError, handler:Function = null):void {
			if (handler != null) {
				_handledErrors.push(new ErrorWithHandler(error, handler));
			} else {
				_unhandledErrors.push(error);
			}
		}

		public function addErrors(errors:CmdErrors):void {
			_handledErrors = _handledErrors.concat(errors._handledErrors);
			_unhandledErrors = _unhandledErrors.concat(errors._unhandledErrors);
		}

		public function callHandlers():void {
			_handledErrors.forEach(function(error:ErrorWithHandler, ...rest):void {
				var handler:Function = error.handler;
				if (handler.length > 0)
					handler(error.error);
				else
					handler();
			})
		}

		public function reset():void {
			_unhandledErrors.length = 0;
			_handledErrors.length = 0;
		}

		public function get haveUnhandledErrors():Boolean {
			return _unhandledErrors.length > 0;
		}

		public function get haveErrors():Boolean {
			return _unhandledErrors.length > 0 || _handledErrors.length > 0;
		}

		public function get message():String {
			if (!haveErrors)
				return "no errors";
			var errors:Vector.<CmdError> = _unhandledErrors.concat();
			_handledErrors.forEach(function(error:ErrorWithHandler, ...rest):void {
				errors.push(error.error);
			});
			var message:String = "";
			errors.forEach(function(error:CmdError, ...rest):void {
				message += error.message + " ";
			});
			return message;
		}
	}
}

import ru.smr.controller.core.CmdError;

class ErrorWithHandler {
	public var error:CmdError;
	public var handler:Function;

	public function ErrorWithHandler(error:CmdError, handler:Function) {
		this.error = error;
		this.handler = handler;
	}
}
