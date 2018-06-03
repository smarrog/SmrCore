package ru.smr.controller.async {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.smr.controller.core.AsyncCmd;
	import ru.smr.controller.core.CmdError;
	import ru.smr.controller.core.CmdErrors;

	public class DelayCmd extends AsyncCmd {
		private var _timer:Timer;
		private var _ms:int;

		public function DelayCmd(ms:int) {
			_ms = ms;
		}

		protected override function executeInternal():void {
			if (_ms == 0) {
				notifyComplete();
				return;
			}
			_timer = new Timer(_ms, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}

		protected override function generateErrors(errors:CmdErrors):void {
			if (_ms < 0) {
				errors.addError(new CmdError("Delay can't be negative"));
			}
		}

		protected override function terminate():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
		}

		private function onTimerComplete(event:TimerEvent):void {
			notifyComplete();
		}
	}
}
