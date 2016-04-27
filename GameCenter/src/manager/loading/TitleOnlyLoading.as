package manager.loading
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import manager.loading.BaseLoading;
	
	/**
	 * 仅有标题，无百分比的loading样式
	 */	
	public class TitleOnlyLoading extends BaseLoading implements ILoading
	{
		
		private static const KEY:String = "titleOnlyLoading";
		
		protected var _titleText:TextField;
		/**
		 * constructor
		 * @param KEY 库中对应的链接ID
		 * 
		 */		
		public function TitleOnlyLoading(parent:DisplayObjectContainer,title:String="Loading...", showCloseBtn:Boolean = false)
		{
			super(parent,showCloseBtn);
			_titleText = _loadingBar["content_txt"];
			if(_titleText)
			{
				_titleText.autoSize = TextFieldAutoSize.CENTER;
				_titleText.text = title;
			}
		}
		
		/**
		 * 设置标题
		 * @param str
		 * 
		 */		
		override public function set title(str:String):void
		{
			if(_titleText) _titleText.text = str;
		}
		/**
		 * 关闭loading
		 * 
		 */		
		override public function destroy():void
		{
			_titleText = null;
			super.destroy();
		}
		override public function get key():String
		{
			return KEY;
		}
	}
}