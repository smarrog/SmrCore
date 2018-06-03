package ru.smr.controller.core {
	public class CmdQueue extends AsyncCmd {
		private var _currentCommand:AsyncCmd;
		private var _commands:Vector.<AsyncCmd> = new <AsyncCmd>[];

		public function CmdQueue() {
			super();
		}

		public function addCmd(cmd:AsyncCmd):CmdQueue {
			if (cmd && !isExecuting && _commands.indexOf(cmd) == -1)
				_commands.push(cmd);
			return this;
		}

		public override function reset():AsyncCmd {
			if (_currentCommand)
				_currentCommand.prevent();
			_currentCommand = null;
			_commands.length = 0;
			return super.reset();
		}

		protected override function executeInternal():void {
			_currentCommand = _commands.shift();
			if (_currentCommand == null) {
				notifyComplete();
				return;
			}
			_currentCommand.execute().then(function(cmd:AsyncCmd):void {
				executeInternal();
			}, onError);
		}

		protected override function preventInternal():void {
			if (_currentCommand)
				_currentCommand.prevent();
			else
				super.preventInternal();
		}
	}
}
