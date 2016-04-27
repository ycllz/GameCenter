package com.lilynumber1.data
{
	import flash.events.Event;
	
	/**
	 * 数据驱动事件
	 * @author tb
	 * 
	 */	
	public class DataChangeEvent extends Event
	{
		/**
		 * 数据改变事件 
		 */		
		public static const DATA_CHANGE:String = "dataChange";
		/**
		 * 数据改变前的事件 
		 */		
		public static const PRE_DATA_CHANGE:String = "preDataChange";
		
		protected var _startIndex:uint;
		protected var _endIndex:uint;
		protected var _changeType:String;
		protected var _items:Array;
		
		public function DataChangeEvent(eventType:String, changeType:String, items:Array, startIndex:int = -1, endIndex:int = -1):void
		{
			super(eventType);
			_changeType = changeType;
			_startIndex = startIndex;
			_items = items;
			_endIndex = (endIndex == -1) ? _startIndex : endIndex;
		}
		
		/**
		 * 数据改变类型
		 * @return 
		 * 
		 */		
		public function get changeType():String
		{
			return _changeType;
		}
		
		/**
		 * 改变的数据 
		 * @return 
		 * 
		 */		
		public function get items():Array
		{
			return _items;
		}
		
		/**
		 * 改变的数据在原数组中的开始索引位置 
		 * @return 
		 * 
		 */		
		public function get startIndex():uint
		{
			return _startIndex;
		}
		
		/**
		 * 改变的数据在原数组中的结束索引位置 
		 * @return 
		 * 
		 */		
		public function get endIndex():uint
		{
			return _endIndex;
		}
		
		override public function toString():String
		{
			return formatToString("DataChangeEvent", "type", "changeType", "startIndex", "endIndex", "bubbles", "cancelable");
		}
		
		override public function clone():Event
		{
			return new DataChangeEvent(type, _changeType, _items, _startIndex, _endIndex);
		}
	}
}