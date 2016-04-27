package com.lilynumber1.events
{
	import flash.events.Event;
	
	import com.lilynumber1.tmf.HeadInfo;
	/**
	 * socket错误事件
	 * @author pig.hong
	 * 
	 */
	public class SocketErrorEvent extends Event
	{
		public static const ERROR:String = "socketError";
		
		private var _headInfo:HeadInfo;
		
		public function SocketErrorEvent(type:String, headInfo:HeadInfo,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_headInfo = headInfo;
		}
		public function get headInfo():HeadInfo
		{
			return _headInfo;
		}
	}
}