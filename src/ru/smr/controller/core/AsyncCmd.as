package ru.smr.controller.core {
	import ru.smr.stuff.Promise;

	public class AsyncCmd extends CmdCore {
		public static const PREVENTED:String = "prevented";

		private var _isExecuting:Boolean;
		private var _isPrevented:Boolean;
		private var _promise:Promise = new Promise();

		public function AsyncCmd() {
			super();
		}

		public final function execute():Promise {
			if (isExecuting || _promise.isCompleted)
				return _promise;
			_isExecuting = true;
			var errors:CmdErrors = createErrors();
			onBeforeTryToExecute();
			if (canExecuteWith(errors)) {
				executeInternal();
			} else {
				if (canHandleWith(errors)) {
					errors.callHandlers();
				}
				onError(errors);
			}
			onAfterTryToExecute();
			return _promise;
		}

		public function addCompleteHandler(handler:Function):AsyncCmd {
			_promise.then(handler);
			return this;
		}

		public function addRejectHandler(handler:Function):AsyncCmd {
			_promise.otherwise(handler);
			return this;
		}

		public final function prevent():void {
			if (_isPrevented || _promise.isCompleted)
				return;
			_isPrevented = true;
			if (_isExecuting)
				preventInternal();
		}

		public function reset():AsyncCmd {
			_isExecuting = false;
			_promise.reset();
			terminate();
			return this;
		}

		protected override function executeInternal():void {
			notifyComplete();
		}

		protected function preventInternal():void {
			_promise.reject(PREVENTED);
		}

		protected function notifyComplete():void {
			_promise.resolve(this);
			terminate();
		}

		protected function onError(error:*):void {
			var errorMessage:String;
			if (error is String) {
				errorMessage = error;
			} else if (error is Error) {
				errorMessage = (error as Error).message;
			} else if (error is CmdError) {
				errorMessage = (error as CmdError).message;
			} else if (error is CmdErrors) {
				errorMessage = (error as CmdErrors).message;
			}
			_promise.reject(errorMessage);
			terminate();
		}

		protected function terminate():void {

		}

		protected function get isExecuting():Boolean {
			return _isExecuting;
		}
	}
}
