package manager.loading
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	/**
	 * loading进度条控制类的接口
	 * @author pig.hong
	 * 
	 */	
	public interface ILoading extends IEventDispatcher
	{
		/**
		 * 改变百分比
		 * 
		 */		
		function setPercent(loaded:Number,total:Number):void;
		/**
		 * 销毁
		 * 
		 */		
		function destroy():void;
		/**
		 * 显示
		 * 
		 */		
		function show():void;
		/**
		 * 隐藏
		 * 
		 */		
		function hide():void;
		
		/**
		 * 设置标题文字 
		 * @param str
		 * 
		 */	
		function set title(str:String):void;
		
		/**
		 * 显示内容文字 
		 * @param str
		 * 
		 */		
		function set text(str:String):void;
		
		/**
		 * 设置关闭按钮是否可见
		 * @param b
		 * 
		 */		
		function set closeEnabled(b:Boolean):void;
		function get parent():DisplayObjectContainer;
		function get loadingBar():DisplayObject;
		function get key():String;
	}
}