package ru.smr.utils {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MCUtils {
		public static function getAnimatedChild(animation:DisplayObjectContainer, ignore:DisplayObjectContainer = null):MovieClip {
			var longestChild:MovieClip = null;
			getAllAnimations(animation, ignore).forEach(function (animation:MovieClip, ...params):void {
				if (!longestChild || (longestChild.totalFrames < animation.totalFrames)) {
					longestChild = animation;
				}
			});
			return longestChild;
		}

		private static function getAllAnimations(container:DisplayObjectContainer, ignore:DisplayObjectContainer = null):Vector.<MovieClip> {
			var animations:Vector.<MovieClip> = new <MovieClip>[];
			if (container && (container != ignore)) {
				if (container is MovieClip) {
					animations.push(container as MovieClip);
				}
				for (var i:int = 0; i < container.numChildren; i++) {
					animations = animations.concat(getAllAnimations(container.getChildAt(i) as DisplayObjectContainer, ignore));
				}
			}
			return animations;
		}

		public static function recursivePlay(animation:DisplayObjectContainer):void {
			manageTimeline(animation, true);
		}

		public static function recursiveStop(animation:DisplayObjectContainer):void {
			manageTimeline(animation, false);
		}

		private static function manageTimeline(animation:DisplayObjectContainer, isStartAnimation:Boolean):void {
			if (!animation)
				return;

			for (var i:int = 0; i < animation.numChildren; ++i) {
				manageTimeline(animation.getChildAt(i) as DisplayObjectContainer, isStartAnimation);
			}

			var mc:MovieClip = animation as MovieClip;
			if (!mc)
				return;

			if (isStartAnimation) {
				mc.play();
			} else {
				mc.stop();
			}
		}

		public static function setChildrenFrame(animation:DisplayObjectContainer, frame:int, ignore:DisplayObjectContainer = null, ignoreSelf:Boolean = true):void {
			if (!animation || (ignore && ignore == animation))
				return;

			if (!ignoreSelf) {
				var host:MovieClip = animation as MovieClip;
				if (host) {
					host.gotoAndStop((frame - 1) % host.totalFrames + 1);
				}
			}

			for (var i:int = 0; i < animation.numChildren; ++i) {
				setChildrenFrame(animation.getChildAt(i) as DisplayObjectContainer, frame, ignore, false);
			}
		}

		public static function playAndDo(mc:MovieClip, f:Function):void {
			if (!mc || f == null)
				return;

			var onEnterFrame:Function = function(event:Event):void {
				if (mc.currentFrame > 1)
					return;
				mc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				f();
			};

			mc.gotoAndPlay(1);
			mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
