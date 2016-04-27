package
{
	import data.ClientConfig;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import manager.LayerManager;
	import manager.ModuleManager;
	
	[SWF(width="800",height="480",backgroundColor="#ffffff")]
	public class Main extends Sprite
	{
		private var _entry:MovieClip;
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
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, initGame);
			loader.load(new URLRequest("assets/gameUI.swf"),
				new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function initGame(event:Event):void 
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