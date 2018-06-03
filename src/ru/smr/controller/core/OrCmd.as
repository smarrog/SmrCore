package ru.smr.controller.core {
	public class OrCmd extends Cmd {
		private var _commands:Vector.<Cmd>;

		public function OrCmd(commands:Vector.<Cmd>) {
			_commands = commands || new <Cmd>[];
		}

		protected override function executeInternal():void {
			_commands.some(function(cmd:Cmd, ...rest):Boolean {
				return cmd.tryToExecute();
			});
		}

		protected override function generateErrors(errors:CmdErrors):void {
			if (!_commands.some(function(cmd:Cmd, ...rest):Boolean {
					return cmd.canExecute;
				}))
				errors.addError(new CmdError("No command can be executed"));
		}
	}
}
