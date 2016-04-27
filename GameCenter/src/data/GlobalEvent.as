package data
{
	import flash.events.Event;
	
	/**
	 * Module事件 全局的事件类型
	 */	
	public class GlobalEvent extends Event
	{
		/**
		 * 播放头退出当前帧时调度
		 */		
		public static const EXIT_FRAME:String = "exitFrame";
		/**
		 * 在帧显示对象的构造函数运行之后但在帧脚本运行之前调度 
		 */		
		public static const FRAME_CONSTRUCTED:String = "frameConstructed";
		/**
		 * 帐号登陆成功
		 */		
		public static const LOGIN_SUCCESS:String = "loginSuccess";
		/**
		 * 怪物点击 
		 */		
		public static const OGRE_CLICK:String = "ogreClick";
		/**
		 * 物体
		 */		
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		public static const DESTROY:String = "destroy";
		
		
		/**
		 * 信息通知 
		 */		
		public static const MESSAGE:String = "message";
		public static const CHANGE_NAME_ERROR:String = "changeNameError";
		
		public function GlobalEvent(type:String)
		{
			super(type);
		}
		
	}
}