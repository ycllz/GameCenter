package data
{
	import flash.events.Event;
	
	/**
	 * UILoader加载器事件 
	 * @author tb
	 * 
	 */
	public class UILoadEvent extends Event
	{
		/**
		 * 加载完成 
		 */		
		public static const COMPLETE:String = Event.COMPLETE;
		/**
		 * 开始加载 
		 */		
		public static const OPEN:String = Event.OPEN;
		/**
		 * 中途关闭加载
		 */	
		public static const CLOSE:String = Event.CLOSE;
			
		private var _loader:UILoader;
		
			
		public function UILoadEvent(type:String,loader:UILoader)
		{
			super(type);
			_loader = loader;
		}
		
		public function get uiloader():UILoader
		{
			return _loader;
		}
	}
}