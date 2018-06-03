package ru.smr.controller.core {
	public class AndCmd extends Cmd {
		private var _commands:Vector.<Cmd>;

		public function AndCmd(commands:Vector.<Cmd>) {
			_commands = commands || new <Cmd>[];
		}

		protected override function executeInternal():void {
			_commands.forEach(function(cmd:Cmd, ...rest):void {
				cmd.tryToExecute();
			});
		}

		protected override function generateErrors(errors:CmdErrors):void {
			_commands.forEach(function(cmd:Cmd, ...rest):Boolean {
				if (!cmd.canExecute) {
					errors.addErrors(cmd.createErrors());
					errors.addError(new CmdError("Block"));
				}
			});
		}
	}
}
