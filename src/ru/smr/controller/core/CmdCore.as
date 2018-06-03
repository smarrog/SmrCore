package ru.smr.controller.core {
	public class CmdCore {
		protected static function canExecuteWith(errors:CmdErrors):Boolean {
			return !errors.haveErrors;
		}

		protected static function canHandleWith(errors:CmdErrors):Boolean {
			return !errors.haveUnhandledErrors;
		}

		public function CmdCore() {

		}

		public final function get canExecute():Boolean {
			return canExecuteWith(createErrors());
		}

		public final function get canHandle():Boolean {
			return canHandleWith(createErrors());
		}

		public final function createErrors():CmdErrors {
			var errors:CmdErrors = new CmdErrors();
			generateErrors(errors);
			return errors;
		}

		protected function executeInternal():void {

		}

		protected function generateErrors(errors:CmdErrors):void {

		}

		protected function onBeforeTryToExecute():void {

		}

		protected function onAfterTryToExecute():void {

		}
	}
}
