package ru.smr.stuff {
	import flash.external.ExternalInterface;

	public class ExternalInterfaceUtil {
		public static function hasJSFunction(func:String):Boolean {
			try {
				return ExternalInterface.call("function(){return typeof " + func + " == 'function'}");
			} catch (e:Error) {

			}
			return false;
		}

		public static function addCallback(callbackName:String, callback:Function):Boolean {
			try {
				ExternalInterface.addCallback(callbackName, callback);
				return true;
			}
			catch (e:Error) {

			}
			return false;
		}

		public static function call(func:String, ...params):* {
			try {
				if (!hasJSFunction(func))
					return false;
				return ExternalInterface.call.apply(null, [func].concat(params));
			}
			catch (e:Error) {

			}
			return false;
		}

		public static function refresh():void {
			call("window.location.reload");
		}

		public static function showApp(show:Boolean):void {
			call("function(){var app = document.getElementById('" + appDomId + "'); " + "if(app){" + "app.style.width = " + (show ? "''; " : "'1px'; ") + "app.style.height = " + (show ? "''; " : "'1px'; ") + "}}");
		}

		private static function get appDomId():String {
			return ExternalInterface.available ? ExternalInterface.objectID : null;
		}
	}
}
