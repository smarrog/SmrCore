package ru.smr.controller.core {
	public class CmdError {
		private var _message:String;

		public function CmdError(message:String) {
			_message = message;
		}

		public function get message():String {
			return _message;
		}
	}
}
