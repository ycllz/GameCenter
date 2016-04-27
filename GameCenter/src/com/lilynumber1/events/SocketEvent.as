package com.lilynumber1.events
{
	import flash.events.Event;
	
	import com.lilynumber1.tmf.HeadInfo;
	
	/**
	 * Socket通讯事件
	 * @author tb
	 * 
	 */
	public class SocketEvent extends Event
	{
		/**
		 * 加载完成,用于多例
		 */		
		public static const COMPLETE:String = Event.COMPLETE;
		
		private var _headInfo:HeadInfo;
		private var _data:Object;
		
		public function SocketEvent(type:String,headInfo:HeadInfo,data:Object)
		{
			super(type, false, false);
			_headInfo = headInfo;
			_data = data;
		}
		
		/**
		 * socket数据包头 
		 * @return 
		 * 
		 */		
		public function get headInfo():HeadInfo
		{
			return _headInfo;
		}
		
		/**
		 * 数据包体 
		 * @return 
		 * 
		 */		
		public function get data():Object
		{
			return _data;
		}
	}
}