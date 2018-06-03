package ru.smr.controller.core {
	public class Cmd extends CmdCore {
		public function Cmd() {
			super();
		}

		public final function tryToExecute():Boolean {
			var errors:CmdErrors = createErrors();
			onBeforeTryToExecute();
			if (canExecuteWith(errors)) {
				executeInternal();
				onAfterTryToExecute();
				return true;
			}
			if (canHandleWith(errors)) {
				errors.callHandlers();
			}
			onAfterTryToExecute();
			return false;
		}
	}
}
