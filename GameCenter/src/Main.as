package
{
	import data.ClientConfig;
	import data.UILoadEvent;
	import data.UILoader;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import manager.LayerManager;
	import manager.LoadingManager;
	import manager.ModuleManager;
	import manager.loading.LoadingType;
	
	[SWF(width="800",height="480",backgroundColor="#ffffff")]
	public class Main extends Sprite
	{
		private var _entry:MovieClip;
		private var _preLoader:Loader;
		private var _loader:UILoader;
		public function Main()
		{
			IFlash.setSize(800, 480); //设置场景尺寸
			IFlash.setOrientationEx(0); //是否为横屏模式
			IFlash.setBgcolor("#ffffff"); //背景色
			IFlash.showInfo(false); //是否显示帧率
			
			var root:Sprite = new Sprite();
			addChild(root);
			LayerManager.setup(root);
			ClientConfig.setup();
			
			_preLoader = new Loader();
			_preLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, initLoading);
			_preLoader.load(new URLRequest("assets/loadingUI.swf"),
				new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function initLoading(event:Event = null):void 
		{
			LoadingManager.setup(_preLoader);
			_loader = new UILoader("assets/gameUI.swf", LayerManager.gameLevel, LoadingType.TITLE_AND_PERCENT,"正在加载……",true,true);
			_loader.addEventListener(UILoadEvent.COMPLETE,onLoadComplete);
			_loader.addEventListener(UILoadEvent.CLOSE,onLoadClose);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_loader.load();
		}
		
		private function onLoadComplete(e:UILoadEvent):void
		{
			_loader.removeEventListener(UILoadEvent.COMPLETE,onLoadComplete);
			_loader.removeEventListener(UILoadEvent.CLOSE,onLoadClose);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			//
			initGame();
		}
		
		private function onLoadClose(e:UILoadEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onError(e:IOErrorEvent):void
		{
			dispatchEvent(e);
		}
		
		private function initGame(event:Event = null):void 
		{
			_entry = new (ApplicationDomain.currentDomain.getDefinition("entryUI") as Class)();
			LayerManager.gameLevel.addChild(_entry);
			_entry.x = _entry.y = 0;
			_entry.addEventListener(MouseEvent.CLICK, _entryHandler);
		}
		
		private function _entryHandler(event:MouseEvent):void
		{
			var btn:SimpleButton = event.target as SimpleButton;
			if(btn == null){
				return;
			}
			switch(btn.name){
				case "jewelleryGame":
					ModuleManager.turnAppModule("JewelleryGameStartPanel");
					break;
				case "pandaRun":
					navigateToURL(new URLRequest("../pandaRun/pandaRun.html"),"_self");
					break;
			}
		}
		
	}
}