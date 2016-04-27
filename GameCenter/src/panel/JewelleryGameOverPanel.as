package panel
{
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import manager.LayerManager;
	import manager.popup.ModalType;
	
	import model.BaseViewModule;

	public class JewelleryGameOverPanel extends BaseViewModule
	{
		private var _arg:Object;
		override public function setup():void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("JewelleryGameOverPanelUI") as Class;
			setMainUI(new cls());
		}
		
		override public function init(data:Object=null):void{
			_arg = data;
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["closeBtn"].addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["closeBtn"].removeEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function closeHandler(event:MouseEvent):void
		{
			destroy();
			if(_arg.close != null){
				_arg.close.call(null);
			}
		}
		
		private function updateView():void
		{
			_mainUI["scoreLabel"].text = _arg.score;
		}
		
		override public function show():void
		{
			_modalType = ModalType.DARK;
			showFor(LayerManager.topLevel);
			updateView();
		}
	}
}