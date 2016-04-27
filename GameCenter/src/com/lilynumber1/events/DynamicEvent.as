package com.lilynumber1.events
{
	import flash.events.Event;
	
	/**
	 * 动态参数事件
	 * @author tb
	 * 
	 */	
	public class DynamicEvent extends Event
	{
		private var _paramObject:*;

		public function DynamicEvent(type:String, paramObject:* = null)
		{
			super(type, false, false);
			_paramObject = paramObject;
		}

		public function get paramObject():*
		{
			return _paramObject;
		}

		override public function clone():Event
		{
			return new DynamicEvent(type, _paramObject);
		}
	}
}

