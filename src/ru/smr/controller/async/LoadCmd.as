package ru.smr.controller.async {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import ru.smr.controller.core.AsyncCmd;
	import ru.smr.controller.core.CmdError;
	import ru.smr.controller.core.CmdErrors;

	public class LoadCmd extends AsyncCmd {
		private var _url:String;
		private var _loader:URLLoader = new URLLoader();

		public function LoadCmd(url:String, dataFormat:String = URLLoaderDataFormat.TEXT) {
			_url = url;
			_loader.dataFormat = dataFormat;
		}

		public function get loadedData():Object {
			return _loader.data;
		}

		protected override function generateErrors(errors:CmdErrors):void {
			if (_url == null || _url.length == 0)
				errors.addError(new CmdError("no url"));
		}

		protected override function executeInternal():void {
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(createUrlRequest());
		}

		protected function createUrlRequest():URLRequest {
			return new URLRequest(_url);
		}

		protected override function terminate():void {
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			super.terminate();
		}

		protected function onLoadComplete(event:Event):void {
			notifyComplete();
		}

		protected function onLoadError(errorEvent:ErrorEvent):void {
			onError(errorEvent.toString());
		}
	}
}
