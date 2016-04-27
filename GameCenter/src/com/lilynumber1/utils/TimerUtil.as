package com.lilynumber1.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * 时间工具
	 * @author JACK
	 *
	 */
	public class TimerUtil
	{

		/****************************
		 *清除所有的计时器,切换场景时执行,为了不被受切换场景清楚,使用Timer或其他计时类.
		 * **************************/
		public static function clearAllTimer():void
		{
			clearAllTimeout()
			clearAllInterval()
		}

		/****************************
		 *清除所有的setTimeout计时器
		 * **************************/
		public static function clearAllTimeout():void
		{
			var timeoutNum:uint=setTimeout(function():void
				{
					timeoutNum=setTimeout(function():void
						{
						}, 0)
					for (var i:uint=1; i <= timeoutNum; i++)
					{
						clearTimeout(i);
					}
				}, 0);
		}

		/****************************
		 *清除所有的setInterval计时器
		 * **************************/
		public static function clearAllInterval():void
		{
			var timeoutNum:uint=setInterval(function():void
				{
					timeoutNum=setInterval(function():void
						{
						}, 0)
					for (var i:uint=1; i <= timeoutNum; i++)
					{
						clearInterval(i);
					}
				}, 0);
		}

		/****************************
		 *自定义setTimeout和setInterval计时器来取代官方的setTimeout..
		 * **************************/

		/**
		 * 等同与setTimeout
		 * @param closure
		 * @param delay
		 * @param vars
		 * @return
		 *
		 */
		public static function setGTimeout(closure:Function, delay:Number, ... vars):Timer
		{
			return getTimerInstance(closure, delay, 1, vars)
		}

		/**
		 * 等同与clearTimeout
		 * @param timer
		 *
		 */

		public static function clearGTimeout(timer:Timer):void
		{
			if (timer)
			{
				timer.stop()
				timer=null
			}
		}

		/**
		 * 等同与setInterval功能
		 * @param closure
		 * @param delay
		 * @param vars
		 * @return
		 *
		 */
		public static function setGInterval(closure:Function, delay:*, ... vars):Timer
		{
			var num:uint
			if (delay as String && delay.indexOf(":") > -1)
			{
				var ta:Array=delay.split(":")
				num=int(ta[1])
				delay=int(ta[0])
			}
			else
			{
				num=0
			}
			return getTimerInstance(closure, delay, num, vars)
		}

		/**
		 * 等同与clearInterval
		 * @param timer
		 *
		 */
		public static function clearGInterval(timer:Timer):void
		{
			if (timer)
			{
				timer.stop()
				timer=null
			}
		}

		/**
		 * 获取一个TIMER实例
		 * @param closure
		 * @param delay
		 * @param num
		 * @param vars
		 * @return
		 *
		 */
		private static function getTimerInstance(closure:Function, delay:Number, num:uint, vars:*):Timer
		{
			var tempTimer:Timer=new Timer(delay, num)
			tempTimer.addEventListener(TimerEvent.TIMER, function(E:TimerEvent):void
				{
					if (E.currentTarget.currentCount == E.currentTarget.repeatCount)
					{
						tempTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee)
						clearGTimeout(tempTimer)
					}
					//
					if (vars.length > 0)
					{
						closure.apply(this, vars)
					}
					else
					{
						closure()
					}
				})
			tempTimer.start()
			return tempTimer
		}

	}
}