package ru.smr.stuff.iso {
	public class IsoMath {
		static private const ratio:int = 2;

		static public function screenToIso(screenPt:IsoPoint, createNew:Boolean = false):IsoPoint {
			if (createNew)
				screenPt = screenPt.clonePt();

			screenPt.y = screenPt.y - screenPt.x / ratio + screenPt.z;
			screenPt.x = 2 * screenPt.x / ratio + screenPt.y;
			return screenPt;
		}

		static public function isoToScreen(isoPt:IsoPoint, createNew:Boolean = false):IsoPoint {
			if (createNew)
				isoPt = isoPt.clonePt();

			isoPt.x = isoPt.x - isoPt.y;
			isoPt.y = ((isoPt.x + isoPt.y) + isoPt.y) / ratio - isoPt.z;
			return isoPt;
		}
	}
}