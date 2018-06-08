package ru.smr.stuff {
	public class BitMask {
		public var value:uint;

		public function BitMask(value:uint = 0) {
			this.value = value;
		}

		public function setValue(index:int, value:Boolean):void {
			if (getValue(index) != value)
				this.value += (1 << index) * (value ? 1 : -1);
		}

		public function getValue(index:int):Boolean {
			return (value & (1 << index)) > 0;
		}

		public function get count():int {
			var amount:int = 0;
			var buf:int = 1;
			while (buf <= value) {
				if (buf & value)
					amount++;
				buf <<= 1;
			}
			return amount;
		}
	}
}
