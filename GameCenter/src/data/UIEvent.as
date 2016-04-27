package data
{
	import flash.events.Event;
	
	/**
	 * 常用UI组件事件
	 * @author richardzhou
	 */
	public class UIEvent extends Event
	{
		/** 按钮组事件 _ 当改变选中的按钮时 data{oldBtn:之前选中按钮,nowBtn:当前选中按钮}**/
		public static const BUTTON_GROUP_CHANGE_SELECTEC_BTN:String="BUTTON_GROUP_CHANGE_SELECTEC_BTN";
		/** 滚动条事件 data:当前显示位置即显示对象顶部坐标**/
		public static const SCROLLBAR_SCROLL:String="SCROLLBAR_SCROLL";
		//翻页事件
		public static const PAGE_CHANGE:String = "page_Change";
		
		public static const OPEN_MODULE:String = "open_module";
		public static const CLOSE_MODULE:String = "close_module";
		/**
		 * 打开特定的NPC对话框 
		 */		
		public static const OPEN_NPC:String = "open_npc";
		/** 事件数据对象 **/
		private var _data:Object;
		
		public function UIEvent(type:String, _data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data=_data;
		}
		
		/**
		 * 返回数据对象
		 * @return
		 */
		public function get data():Object
		{
			return _data;
		}
	}
}
