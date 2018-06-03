package ru.smr.utils {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DisplayUtils {
		public static const PAN_AND_SCAN:String = "panAndScan";
		public static const LETTERBOX:String = "letterbox";

		public static const RAD_TO_ANGLE:Number = 180 / Math.PI;
		public static const ANGLE_TO_RAD:Number = Math.PI / 180;

		public static function radToAngle(rad:Number):Number {
			return rad * RAD_TO_ANGLE;
		}
		
		public static function angleToRad(angle:Number):Number {
			return angle * ANGLE_TO_RAD;
		}

		public static function angleBetweenPoints(x1:Number, x2:Number, y1:Number, y2:Number):Number {
			return Math.atan2(y1 - y2, x1 - x2);
		}

		public static function radBetweenPoints(x1:Number, x2:Number, y1:Number, y2:Number):Number {
			return radToAngle(angleBetweenPoints(x1, x2, y1, y2));
		}

		public static function flipBitmapData(original:BitmapData, xAxis:Boolean = false, yAxis:Boolean = false):BitmapData {
			var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
			var matrix:Matrix = new Matrix(1, 0, 0, 1, original.width, original.height);

			if (xAxis) {
				matrix.a = -1;
				matrix.ty = 0;
			}
			if (yAxis) {
				matrix.d = -1;
				matrix.tx = 0;
			}

			flipped.draw(original, matrix, null, null, null, true);
			return flipped;
		}

		public static function getVisibleBitmapData(mc:DisplayObject):BitmapData {
			var rect:Rectangle = mc.getBounds(mc);
			if (rect.width <= 0 || rect.height <= 0)
				return new BitmapData(1, 1);

			var rawBitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x0);
			var position:Point = rect.topLeft;
			var matrix:Matrix = new Matrix;
			matrix.translate(-rect.left, -rect.top);
			rawBitmapData.draw(mc, matrix);

			var visibleBounds:Rectangle = rawBitmapData.getColorBoundsRect(0xFF000000, 0, false);

			var windowBitmap:BitmapData = rawBitmapData;
			if (visibleBounds.height > 0 && visibleBounds.width > 0) {
				position.offset(visibleBounds.x, visibleBounds.y);
				windowBitmap = new BitmapData(visibleBounds.width, visibleBounds.height, true, 0x0);
				windowBitmap.copyPixels(rawBitmapData, visibleBounds, new Point(0, 0));
				rawBitmapData.dispose();
			}
			return windowBitmap;
		}

		public static function getVisibleBounds(target:DisplayObject, targetCoordinateSpace:DisplayObject):Rectangle {
			var rect:Rectangle = target.getBounds(target);
			if (rect.width <= 0 || rect.height <= 0)
				return new Rectangle();

			var matrix:Matrix = new Matrix;
			matrix.translate(-rect.left, -rect.top);

			var rawBitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x0);
			rawBitmapData.draw(target, matrix);

			rect = target.getBounds(targetCoordinateSpace);
			var visibleBounds:Rectangle = rawBitmapData.getColorBoundsRect(0xFF000000, 0, false);
			visibleBounds.x += rect.x;
			visibleBounds.y += rect.y;
			rawBitmapData.dispose();

			return visibleBounds;
		}

		public static function bilinear(source:BitmapData, width:uint, height:uint, method:String, allowEnlarging:Boolean = true):BitmapData {
			var scale:Point = DisplayUtils.scale(new Point(source.width, source.height), new Point(width, height), method, allowEnlarging);
			var result:BitmapData = new BitmapData(width, height, true, 0x0);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale.x, scale.y);
			matrix.tx = (width - source.width * scale.x) / 2;
			matrix.ty = (height - source.height * scale.y) / 2;
			result.draw(source, matrix, null, null, null, true);
			return result;
		}

		private static function scale(origDimensions:Point, containerDimensions:Point, method:String, allowEnlarging:Boolean = true):Point {
			var sw:Number = containerDimensions.x / origDimensions.x;
			var sh:Number = containerDimensions.y / origDimensions.y;
			var sx:Number = sw;
			var sy:Number = sh;
			if (method == PAN_AND_SCAN) {
				sx = sy = Math.max(sw, sh);
			} else if (method == LETTERBOX) {
				sx = sy = Math.min(sw, sh);
			}
			if (!allowEnlarging) {
				sx = Math.min(1, sx);
				sy = Math.min(1, sy);
			}
			return new Point(sx, sy);
		}
	}
}
