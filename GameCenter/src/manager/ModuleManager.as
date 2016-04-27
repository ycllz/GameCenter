package manager
{
	import data.GlobalEvent;
	import data.PanelType;
	import data.UIEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import model.AppModel;
	
	import com.lilynumber1.ds.HashMap;
	
	/**
	 * 模块管理，创建获取单例应用模块
	 */	
	public class ModuleManager
	{
		private static var _moduleMap:HashMap = new HashMap();
		public static var event:EventDispatcher = new EventDispatcher();
		
		/**
		 * 获得一个模块 
		 * @param url
		 * @param title
		 * @return 
		 * 
		 */		
		public static function getModule(url:String, title:String):AppModel
		{
			var app:AppModel = _moduleMap.getValue(url);
			if(app)
			{
				return app;
			}
			app = new AppModel(url);
			app.depth = _moduleMap.getKeys().length;
			_moduleMap.add(url,app);
			return app;
		}
		
		public static function turnModule(url:String, title:String,data:Object = null):void
		{
			var app:AppModel = _moduleMap.getValue(url);
			if(app)
			{
				if(app.hasParent && app.toggle)
				{
					app.hide();
				}
				else
				{
					if(data != null)
					{
						app.init(data);
					}
					app.show();
				}
				return ;
			}
			app = new AppModel(url);
			app.depth = _moduleMap.getKeys().length;
			
			_moduleMap.add(url,app);
			app.setup();
			if(data != null)
			{
				app.init(data);
			}
			app.show();
			
			app.addEventListener(GlobalEvent.DESTROY,onModuleDestroy);
			
			event.dispatchEvent(new UIEvent(UIEvent.OPEN_MODULE,url));
		}
		
		private static function onModuleDestroy(e:GlobalEvent):void
		{
			(e.currentTarget as IEventDispatcher).removeEventListener(GlobalEvent.DESTROY,onModuleDestroy);
			
			event.dispatchEvent(new UIEvent(UIEvent.CLOSE_MODULE,(e.currentTarget as AppModel).url));
		}
		
		public static function turnAppModule(name:String, title:String="正在加载...", data:Object = null):void
		{
			turnModule(name,title,data);
		}
		
		public static function turnGameModule(name:String, title:String,data:Object = null):void
		{
			turnModule(name,title,data);
		}
		
		public static function showModule(url:String, title:String,data:Object = null):void
		{
			var app:AppModel = _moduleMap.getValue(url);
			if(app)
			{
				if(data)
				{
					app.init(data);
				}
				app.show();
				return ;
			}
			app = new AppModel(url);
			app.depth = _moduleMap.getKeys().length;
			_moduleMap.add(url,app);
			app.setup();
			if(data != null)
			{
				app.init(data);
			}
			app.show();
		}
		
		public static function hideModule(url:String):void
		{
			var app:AppModel = _moduleMap.getValue(url);
			if(app)
			{
				app.hide();
			}
		}
		public static function hasModule(url:String):Boolean
		{
			return _moduleMap.containsKey(url);
		}
		public static function remove(url:String):void
		{
			_moduleMap.remove(url);
		}
		public static function destroy(url:String):void
		{
			var app:AppModel = _moduleMap.remove(url);
			if(app)
			{
				app.destroy();
				app = null;
			}
		}
		
		public static function closeAllModule():void
		{
			var arr:Array = _moduleMap.getValues();
			for each (var app:AppModel in arr)
			{
				if(app)
				{
					if(app.hasParent)
					{
						app.hide();
					}
				}
			}
		}
		
		public static function destoryAllModule():void
		{
			var arr:Array = _moduleMap.getValues();
			for each (var app:AppModel in arr)
			{
				if(app)
				{
					if(app.hasParent)
					{
						app.destroy();
					}
				}
			}
		}
	}
}
