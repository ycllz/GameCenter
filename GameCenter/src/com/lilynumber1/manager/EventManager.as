package com.lilynumber1.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 事件中心，全局事件
	 * @author tb
	 * 
	 */
	 
	public class EventManager
	{
		public function EventManager()
		{
			if (!isSingle){
				throw new Error("EventManager为单例模式，不能直接创建");
			}
		}
		
		/**
		 * 获取单例 
		 */		
		private static var instance:EventDispatcher;
		private static var isSingle:Boolean = false;
		private static function getInstance():EventDispatcher
		{
			if (instance == null)
			{
				isSingle = true;
				instance = new EventDispatcher();
			}
			isSingle = false;
			return instance;
		}
		
		
		/**
		 * 事件
		 */	
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			getInstance().removeEventListener(type, listener, useCapture);
		}
		public static function dispatchEvent(event:Event):void
		{
			getInstance().dispatchEvent(event);
		}
		public static function hasEventListener(type:String):Boolean
		{
			return getInstance().hasEventListener(type);
		}
		public static function willTrigger(type:String):Boolean
		{
			return getInstance().willTrigger(type);
		}
	}
}