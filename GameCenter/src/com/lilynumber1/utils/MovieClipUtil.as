package com.lilynumber1.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * 影片剪辑功能
	 * @author tb
	 *
	 */
	public class MovieClipUtil
	{
		/**
		 * 播放完并移除 
		 * @param mc
		 * 
		 */		
		public static function playEndAndRemove(mc:MovieClip):void
		{
			mc.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					if(mc.currentFrame == mc.totalFrames)
					{
						mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
						DisplayUtil.removeForParent(mc);
						mc = null;
					}
				});
		}
		
		/**
		 * 获取容器的子影片剪辑并停止
		 * @param obj
		 * @param frame
		 * @param level
		 * 
		 */		
		public static function childStop(obj:DisplayObjectContainer, frame:Object, level:uint = 0):void
		{
			var count:int = 0;
			var num:int = obj.numChildren;
			if (num == 0)
			{
				return;
			}
			if (level >= num)
			{
				level = num - 1;
			}
			obj.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					var mc:MovieClip = obj.getChildAt(level) as MovieClip;
					if (mc)
					{
						obj.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						mc.gotoAndStop(frame);
					}
					else
					{
						if (count > 2)
						{
							obj.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						}
					}
					count++;
				});
		}
		
		/**
		 * 获取容器的子影片剪辑并播放
		 * @param obj
		 * @param frame
		 * @param level
		 * 
		 */		
		public static function childPlay(obj:DisplayObjectContainer, frame:Object, level:uint = 0):void
		{
			var count:int = 0;
			var num:int = obj.numChildren;
			if (num == 0)
			{
				return;
			}
			if (level >= num)
			{
				level = num - 1;
			}
			obj.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					var mc:MovieClip = obj.getChildAt(level) as MovieClip;
					if (mc)
					{
						obj.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						mc.gotoAndPlay(frame);
					}
					else
					{
						if (count > 2)
						{
							obj.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						}
					}
					count++;
				});
		}
	}
}