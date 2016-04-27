package manager
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class LayerManager
	{
		public static const MAX_WIDTH:int = 800;
		public static const MIN_WIDTH:int = 400;
		
		public static const MAX_HEIGHT:int = 480;
		public static const MIN_HEIGHT:int = 240;
		
		
		
		/**
		 * 游戏舞台宽 
		 */		
		public static var stageWidth:int = 800;
		
		/**
		 * 游戏舞台高 
		 */				
		public static var stageHeight:int = 480;
		//
		//根
		private static var _root:Sprite;
		private static var _stage:Stage;
		//游戏层
		private static var _gameLevel:Sprite;
		//顶层：特殊情况使用的层级
		private static var _topLevel:Sprite;
		private static var _alertLevel:Sprite;
		//界面层
		private static var _uiLevel:Sprite;
		//工具层
		private static var _toolsLevel:Sprite;
		//工具界面层。 切换界面时不会被清空 
		private static var _toolUiLevel:Sprite;
		//地图层
		private static var _mapLevel:Sprite;
		
		public static function setup(con:Sprite):void
		{
			if(con.hasOwnProperty("clientWidth"))
			{
				stageWidth = int(con["clientWidth"]);
			}
			else if(stage)
			{
				stageWidth = stage.stageWidth;
			}
			if(con.hasOwnProperty("clientHeight"))
			{
				stageHeight = int(con["clientHeight"]);
			}
			else if(stage)
			{
				stageHeight = stage.stageHeight;
			}
			
			_root = con;
			_stage = _root.stage;
			//0层 地图层
			_mapLevel = new Sprite();
			_mapLevel.mouseEnabled = false;
			_mapLevel.name = "mapLevel";
			_root.addChild(_mapLevel);
			_toolUiLevel = new Sprite();
			_toolUiLevel.mouseEnabled = false;
			_toolUiLevel.name = "toolUiLevel";
			_root.addChild(_toolUiLevel);
			//1层 UI层
			_uiLevel = new Sprite();
			_uiLevel.mouseEnabled = false;
			_uiLevel.name = "uiLevel";
			_root.addChild(_uiLevel);
			//2层 工具层
			_toolsLevel = new Sprite();
			_toolsLevel.mouseEnabled = false;
			_toolsLevel.name = "toolsLevel";
			_root.addChild(_toolsLevel);
			//2层 游戏层
			_gameLevel = new Sprite();
			_gameLevel.mouseEnabled = false;
			_gameLevel.name = "gameLevel";
			_root.addChild(_gameLevel);
			//3层 顶层
			_topLevel = new Sprite();
			_topLevel.mouseEnabled = false;
			_topLevel.name = "topLevel";
			_root.addChild(_topLevel);
			
			_alertLevel = new Sprite();
			_alertLevel.mouseEnabled = false;
			_alertLevel.name = "alertLevel";
			_root.addChild(_alertLevel);
		}
		
		public static function get root():Sprite
		{
			return _root;
		}
		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static function removeRoot():void
		{
			_stage.removeChild(_root);
		}
		
		public static function addRoot():void
		{
			_stage.addChildAt(_root,0);
		}
		
		/**
		 * 地图层 
		 * @return 
		 * 
		 */		
		public static function get mapLevel():Sprite
		{
			return _mapLevel;
		}
		
		/**
		 * ui层 
		 * @return 
		 * 
		 */		
		public static function get uiLevel():Sprite
		{
			return _uiLevel;
		}
		
		/**
		 * 工具层 
		 * @return 
		 * 
		 */		
		public static function get toolsLevel():Sprite
		{
			return _toolsLevel;
		}
		
		/**
		 * 游戏层 
		 * @return 
		 * 
		 */		
		public static function get gameLevel():Sprite
		{
			return _gameLevel;
		}
		
		/**
		 * 顶层 
		 * @return 
		 * 
		 */		
		public static function get topLevel():Sprite
		{
			return _topLevel;
		}
		
		public static function get alertLevel():Sprite
		{
			return _alertLevel;
		}
		
		//--------------------------------------------------------
		// public static function
		//--------------------------------------------------------
		
		/**
		 * 获取舞台中心点 
		 * @return 
		 * 
		 */		
		public static function get stageCenterPoint():Point
		{
			return new Point(stageWidth/2,stageHeight/2);
		}
		
		/**
		 * 开启鼠标事件 
		 * 
		 */		
		public static function openMouseEvent():void
		{
			_mapLevel.mouseChildren = true;
			_uiLevel.mouseChildren = true;
			_toolsLevel.mouseChildren = true;
			_gameLevel.mouseChildren = true;
			_topLevel.mouseChildren = true;
			_toolUiLevel.mouseChildren = true;
		}
		
		/**
		 *  关闭鼠标事件 
		 * @param isTop 是否禁止Top层，默认为false
		 * 
		 */		
		public static function closeMouseEvent(isTop:Boolean=false,isTools:Boolean=true):void
		{
			_mapLevel.mouseChildren = false;
			_uiLevel.mouseChildren = false;
			if(isTools)
			{
				_toolsLevel.mouseChildren = false;
			}
			_gameLevel.mouseChildren = false;
			if(isTop)
			{
				_topLevel.mouseChildren = false;
			}
			_toolUiLevel.mouseChildren = false;
		}
		
		public static function get toolUiLevel():Sprite
		{
			return _toolUiLevel;
		}
	}
}