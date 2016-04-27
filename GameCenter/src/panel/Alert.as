package panel
{
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import manager.LayerManager;
	import manager.popup.ModalType;
	
	import model.BaseViewModule;

	public class Alert extends BaseViewModule
	{
		private var _arg:Object;
		override public function setup():void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("AlertUI") as Class;
			setMainUI(new cls());
		}
		
		override public function init(data:Object=null):void{
			_arg = data;
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["okBtn"].addEventListener(MouseEvent.CLICK, okHandler);
			_mainUI["cancelBtn"].addEventListener(MouseEvent.CLICK, cancelHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["okBtn"].removeEventListener(MouseEvent.CLICK, okHandler);
			_mainUI["cancelBtn"].removeEventListener(MouseEvent.CLICK, cancelHandler);
		}
		
		private function okHandler(event:MouseEvent):void
		{
			destroy();
			if(_arg.ok != null){
				_arg.ok.call(null);
			}
		}
		
		private function cancelHandler(event:MouseEvent):void
		{
			destroy();
		}
		
		private function updateView():void
		{
			_mainUI["txt"].text = _arg.txt;
		}
		
		override public function show():void
		{
			_modalType = ModalType.DARK;
			showFor(LayerManager.topLevel);
			updateView();
		}
	}
}