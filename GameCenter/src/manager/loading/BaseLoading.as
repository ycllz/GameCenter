package manager.loading
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import manager.LoadingManager;
	
	import com.lilynumber1.utils.DisplayUtil;
	
	[Event(name="close",type="flash.events.Event")]
	
	/**
	 * 仅仅有图标，其它什么都没有的进度条样式类
	 * @author tb
	 * 
	 */	
	public class BaseLoading extends EventDispatcher implements ILoading
	{
		private static const KEY:String = "baseLoading";
		protected var _loadingBar:MovieClip;//loading样式的MC
		protected var _parent:DisplayObjectContainer;//显示loading的父级容器
		protected var _percent:Number;//加载的百分比
		protected var _closeEnabled:Boolean;//是否显示关闭按钮
		protected var _closeBtn:InteractiveObject;
		protected var _percentBar:DisplayObject;//进度条显示对象
		protected var _percentText:TextField;//百分比文本框
		
		/**
		 * constructor
		 * @param _parent 用来添加loading的容器
		 * @param showCloseBtn 是否显示关闭按钮
		 * 
		 */		
		public function BaseLoading(parent:DisplayObjectContainer = null, closeEnabled:Boolean = false)
		{
			_parent = parent;
			_loadingBar = getLoadingBar();
			_closeBtn = _loadingBar["closeBtn"];
			_percentBar = _loadingBar["loadingbar"];
			_percentText = _loadingBar["perNum"];
			//
			if(_percentText)
			{
				_percentText.text = "0%";
			}
			if(_closeBtn)
			{
				if (_closeBtn is Sprite)
				{
					Sprite(_closeBtn).buttonMode = true;
				}
			}
			this.closeEnabled = closeEnabled;
		}
		
		protected function getLoadingBar():MovieClip
		{
			return LoadingManager.getMovieClip(key);
		}
		
		/**
		 * 改变百分比，子类覆盖此方法
		 * 
		 */		
		public function setPercent(loaded:Number,total:Number):void
		{
			_percent = Math.floor(loaded/total*100);
		}
		
		/**
		 * 显示
		 * 
		 */		
		public function show():void
		{
			if(_parent)
			{
				_parent.addChild(_loadingBar);
			}
		}
		/**
		 * 关闭loading
		 * 
		 */		
		public function hide():void
		{
			DisplayUtil.removeForParent(_loadingBar);
		}
		/**
		 * 销毁
		 * 
		 */		
		public function destroy():void
		{
			if(_closeBtn != null)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK,onCloseHandler);
				_closeBtn = null;
			}
			DisplayUtil.removeForParent(_loadingBar);
			_loadingBar = null;
			_parent = null;
			_percentText = null;
		}
		
		//-------------------------------
		// getter and setter
		//-------------------------------
		public function get loadingBar():DisplayObject
		{
			return _loadingBar;
		}
		
		public function get parent():DisplayObjectContainer
		{
			return _parent;
		}
		/**
		 * 设置是关闭按钮是否可见
		 * @param i true or false
		 * 
		 */		
		public function set closeEnabled(b:Boolean):void
		{
			_closeEnabled = b;
			if (_closeBtn != null)
			{
				if(_closeEnabled)
				{
					_closeBtn.visible = _closeEnabled;
					_closeBtn.addEventListener(MouseEvent.CLICK,onCloseHandler);
				}
				else
				{
					_closeBtn.visible = _closeEnabled;
					_closeBtn.removeEventListener(MouseEvent.CLICK,onCloseHandler);
				}
			} 
		}
		/**
		 * 设置标题，子类覆盖此方法
		 * @param str 标题文字
		 * 
		 */		
		public function set title(str:String):void
		{
			
		}
		/**
		 * 获取库中的loading样式的链接ID，子类覆盖此方法以获得不同的样式MC
		 * @return 
		 * 
		 */		
		public function get key():String
		{
			return KEY;
		}
		
		public function set text(str:String):void
		{
			
		}
		
		
		/**
		 * 鼠标点击关闭按钮事件
		 * @param event
		 * 
		 */		
		private function onCloseHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}