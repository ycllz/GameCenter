package panel
{
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.system.ApplicationDomain;
	
	import manager.LayerManager;
	import manager.ModuleManager;
	import manager.popup.ModalType;
	
	import model.BaseViewModule;

	public class JewelleryGameStartPanel extends BaseViewModule
	{
		override public function setup():void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("JewelleryGameStartPanelUI") as Class;
			setMainUI(new cls());
			updateView();
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["enterBtn"].addEventListener(MouseEvent.CLICK, enterHandle);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			_mainUI["enterBtn"].removeEventListener(MouseEvent.CLICK, enterHandle);
		}
		
		private function enterHandle(event:MouseEvent):void
		{
			doEnter();
		}
		
		private function doEnter():void
		{
			ModuleManager.turnAppModule("JewelleryGamePanel");
			destroy();
		}
		
		private function updateView():void
		{
			var so:SharedObject = SharedObject.getLocal(JewelleryGamePanel.HIGHEST_SCORE);
			var score:int = 0;
			if(so.data[JewelleryGamePanel.HIGHEST_SCORE]){
				score = int(so.data[JewelleryGamePanel.HIGHEST_SCORE]);
			}
				
			_mainUI["totalScoreLabel"].text = String(score);
		}
		
		override public function show():void
		{
			_modalType = ModalType.DARK;
			showFor(LayerManager.topLevel);
		}
	}
}