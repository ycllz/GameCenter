package model
{
	import data.ClientConfig;
	import data.GlobalEvent;
	import data.PanelType;
	import data.UILoadEvent;
	import data.UILoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.getDefinitionByName;
	
	import manager.LayerManager;
	import manager.ModuleManager;
	import manager.loading.LoadingType;
	
	import com.lilynumber1.module.IDisplayModule;
	
	import util.Logger;
	
	/**
	 * 应用功能模块代理
	 * @author tb
	 *
	 */
	public class AppModel extends EventDispatcher
	{
		//是否可使用Esc关闭
//		public var isEsc:Boolean = true;
		
		private var _state:int = PanelType.HIDE;//当前状态
//		private var _isLoading:Boolean = false;//是否正在加载
		private var _url:String;//模块地址
//		private var _title:String;//加载模块显示的标题
		private var _mode:IDisplayModule;//模块
		private var _data:Object;//数据
//		private var _loader:UILoader;//加载器
		private var _events:IEventDispatcher = new EventDispatcher();//模块事件,用于模块还没加载完成就可以侦听
		//
		private var _depth:int; //深度
		public function AppModel(url:String)
		{
			_url = url;
//			_title = title;
		}
		
		//------------------------------------------------------
		// get set
		//------------------------------------------------------
		
		public function get url():String
		{
			return _url;
		}
		public function get events():IEventDispatcher
		{
			return _events;
		}
		public function get module():IDisplayModule
		{
			return _mode;
		}
		public function get hasParent():Boolean
		{
			if(_mode)
			{
				return _mode.parentContainer == null?false:true;
			}
			return false;
		}
		
		//------------------------------------------------------
		// public function
		//------------------------------------------------------
		
		public function setup():void
		{
			if(_mode)
			{
				return ;
			}
			_mode = ClientConfig.moduleMap.getValue(url);
			_mode.setup();
			_mode.addEventListener(GlobalEvent.SHOW,onModeShow);
			_mode.addEventListener(GlobalEvent.HIDE,onModeHide);
			_mode.addEventListener(GlobalEvent.DESTROY,onModeDestroy);
			_events = _mode as IEventDispatcher;
			if(_data != null)
			{
				_mode.init(_data);
			}
			if(_state == PanelType.SHOW)
			{
				_mode.show();
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function init(data:Object = null):void
		{
			_data = data;
			
			if(_mode)
			{
				_mode.init(data);
			}
			setup();
		}
		
		public function show():void
		{
			_state = PanelType.SHOW;
			if(!hasParent || !toggle)
			{
				if(_mode)
				{
					_mode.show();
				}
			}
			setup();
		}
		
		public function hide():void
		{
			_state = PanelType.HIDE;
			if(hasParent)
			{
				_mode.hide();
			}
		}
		
		public function destroy():void
		{
			clearModeEvent();
			if(_mode)
			{
				_mode.destroy();
				_mode = null;
			}
			_data = null;
			_events = null;
			dispatchEvent(new GlobalEvent(GlobalEvent.DESTROY));
		}
		
		//------------------------------------------------------
		// private function
		//------------------------------------------------------
		
		private function clearModeEvent():void
		{
			if(_mode)
			{
				_mode.removeEventListener(GlobalEvent.SHOW,onModeShow);
				_mode.removeEventListener(GlobalEvent.HIDE,onModeHide);
				_mode.removeEventListener(GlobalEvent.DESTROY,onModeDestroy);
			}
		}
		//------------------------------------------------------
		// event load
		//------------------------------------------------------
		
		public function get toggle():Boolean
		{
			if(_mode == null || !Object(_mode).hasOwnProperty('toggle')) return true;
			else return _mode['toggle'];
		}
		
		//------------------------------------------------------
		// event mode
		//------------------------------------------------------
		
		private function onModeShow(e:Event):void
		{
			_state = PanelType.SHOW;
			dispatchEvent(e);
		}
		private function onModeHide(e:Event):void
		{
			_state = PanelType.HIDE;
			dispatchEvent(e);
		}
		private function onModeDestroy(e:Event):void
		{
			ModuleManager.remove(_url);
			clearModeEvent();
			if(_mode)
			{
				_mode = null;
			}
			_data = null;
			_events = null;
			dispatchEvent(new GlobalEvent(GlobalEvent.DESTROY));
		}
		//
		public function get state():uint
		{
			return _state;
		}
		
		public function get depth():int
		{
			return _depth;
		}
		
		public function set depth(value:int):void
		{
			_depth = value;
		}
	}
}