package ru.smr.stuff {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class KeyBoardTracker {
		static private const KEY_DOWN:String = "key_down";
		static private const KEY_UP:String = "key_up";
		static private const KEY_PRESS:String = "key_press"; // при нажатии первый раз

		private var _stage:Stage;
		private var _pressedKeys:Dictionary = new Dictionary();
		private var _triggers:Dictionary = new Dictionary();
		private var _combinations:CombinationStorage = new CombinationStorage();

		public function KeyBoardTracker(stage:Stage) {
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function dispose():void {
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function addUpTrigger(keyCode:int, handler:Function):void {
			addTrigger(KEY_UP, keyCode, handler);
		}

		public function addDownTrigger(keyCode:int, handler:Function):void {
			addTrigger(KEY_DOWN, keyCode, handler);
		}

		public function addPressTrigger(keyCode:int, handler:Function):void {
			addTrigger(KEY_PRESS, keyCode, handler);
		}

		public function removePressTrigger(keyCode:uint, handler:Function):void {
			removeTrigger(KEY_PRESS, keyCode, handler);
		}

		public function removeDownTrigger(keyCode:uint, handler:Function):void {
			removeTrigger(KEY_DOWN, keyCode, handler);
		}

		public function removeUpTrigger(keyCode:uint, handler:Function):void {
			removeTrigger(KEY_UP, keyCode, handler);
		}

		public function addCombinationTrigger(keys:Array, handler:Function):void {
			var keysCombination:KeysCombination = new KeysCombination(keys);
			if (keysCombination.isValid && handler != null) {
				getCombinationStorageFor(keysCombination).handlers[handler] = true;
			}
		}

		public function removeCombinationTrigger(keys:Array, handler:Function):void {
			delete getCombinationStorageFor(new KeysCombination(keys))[handler];
		}

		public function isKeyDown(keyCode:uint):Boolean {
			return _pressedKeys[keyCode];
		}

		private function addTrigger(triggerType:String, keyCode:int, handler:Function):void {
			if (handler != null) {
				getTriggersFor(triggerType, keyCode)[handler] = true;
			}
		}

		private function removeTrigger(triggerType:String, keyCode:int, handler:Function):void {
			delete getTriggersFor(triggerType, keyCode)[handler];
		}

		private function checkTrigger(triggerType:String, keyCode:int):void {
			if (_stage.focus != null && _stage.focus != _stage)
				return;
			for (var handler:* in getTriggersFor(triggerType, keyCode)) {
				handler(keyCode);
			}
		}

		private function onKeyUp(event:KeyboardEvent):void {
			delete _pressedKeys[event.keyCode];
			checkTrigger(KEY_UP, event.keyCode);
		}

		private function onKeyDown(event:KeyboardEvent):void {
			if (!_pressedKeys[event.keyCode]) {
				checkTrigger(KEY_PRESS, event.keyCode);
				checkCombinationsWith(event.keyCode);
			}
			_pressedKeys[event.keyCode] = true;
			checkTrigger(KEY_DOWN, event.keyCode);
		}

		private function getTriggersFor(triggerType:String, keyCode:int):Dictionary {
			_triggers[triggerType] ||= new Dictionary();
			_triggers[triggerType][keyCode] ||= new Dictionary();
			return _triggers[triggerType][keyCode];
		}

		private function getCombinationStorageFor(keysCombination:KeysCombination):CombinationStorage {
			var combinationStorage:CombinationStorage = _combinations;
			keysCombination.keys.forEach(function(keyCode:int, ...rest):void {
				combinationStorage[keyCode] = new CombinationStorage();
				combinationStorage = combinationStorage[keyCode];
			});
			return combinationStorage;
		}

		private function checkCombinationsWith(keyCodeJustPressed:int):void {
			checkCombinationInternal(_combinations, keyCodeJustPressed);
		}

		private function checkCombinationInternal(combinationStorage:CombinationStorage, keyCodeJustPressed:int):void {
			for (var prop:String in combinationStorage) {
				var keyCode:int = int(prop);
				if (keyCode != keyCodeJustPressed && !isKeyDown(keyCode))
					continue;
				var innerCombinationStorage:CombinationStorage = combinationStorage[keyCode];
				var needToCall:Boolean = (keyCodeJustPressed == keyCode) || (keyCodeJustPressed == -1);
				if (needToCall) {
					for (var handler:* in innerCombinationStorage.handlers) {
						handler();
					}
				}
				checkCombinationInternal(innerCombinationStorage, needToCall ? -1 : keyCodeJustPressed);
			}
		}
	}
}

import flash.utils.Dictionary;

class KeysCombination {
	private var _keys:Array;

	public function KeysCombination(keys:Array) {
		var keysFormatted:Array = [];
		if (keys) {
			keys.forEach(function (keyCode:int, ...params):void {
				if (keysFormatted.indexOf(keyCode) == -1)
					keysFormatted.push(keyCode);
			});
		}
		keysFormatted.sort();
		_keys = keysFormatted;
	}

	public function get keys():Array {
		return _keys;
	}

	public function get isValid():Boolean {
		return _keys.length >= 2;
	}
}

dynamic class CombinationStorage {
	public var handlers:Dictionary = new Dictionary();
}