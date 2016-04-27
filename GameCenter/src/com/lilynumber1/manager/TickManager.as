package com.lilynumber1.manager
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import com.lilynumber1.ds.HashSet;
	
	/**
	 * 系统时钟
	 * @author tb
	 * 
	 */	
	public class TickManager
	{
		private static var _hashSet:HashSet = new HashSet();
		private static var _interval:Number = 40;
		private static var _id:uint = 0;
		private static var _running:Boolean;
		
		//--------------------------------------------------------------
		// get set
		//--------------------------------------------------------------
		
		public static function setup():void
		{
			//每40毫秒触发一次，速率就是25次/秒，相当于FPS=25
			_id = setInterval(onTick, _interval);
			_running = true;
		}
		
		/**
		 *设置tick间隔
		 * @param time
		 */
		public static function set interval(time:Number):void
		{
			_interval = time;
			clearInterval(_id);
			_running = false;
			setup();
		}
		public static function get interval():Number
		{
			return _interval;
		}
		
		public static function get running():Boolean
		{
			return _running;
		}
		
		//--------------------------------------------------------------
		// public static function
		//--------------------------------------------------------------
		
		public static function play():void
		{
			if(!_running){
				setup();
			}
		}
		
		public static function stop():void
		{
			if(_running){
				clearInterval(_id);
				_running = false;
			}
		}
		
		/**
		 * 根据真实时间（毫秒）得到帧数
		 */
		public static function getFrameForTime(t:Number):Number
		{
			return t / _interval;
		}

		/**
		 * 根据帧数得到真实时间（毫秒）
		 */
		public static function getTimeForFrame(f:Number):Number
		{
			return f * _interval;
		}
		
		/**
		 * 事件
		 */	
		public static function addListener(listener:Function):void
		{
			_hashSet.add(listener);
		}
		public static function removeListener(listener:Function):void
		{
			_hashSet.remove(listener);
		}
		
		public static function hasListener(listener:Function):Boolean
		{
			return _hashSet.contains(listener);
		}
		
		//--------------------------------------------------------------
		// private static function
		//--------------------------------------------------------------
		
		private static function onTick():void
		{
			_hashSet.each2(function(func:Function):void
			{
				func();
			});
		}
	}
}

