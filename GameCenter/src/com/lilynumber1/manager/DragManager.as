package com.lilynumber1.manager
{
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.lilynumber1.ds.HashMap;
	import com.lilynumber1.manager.DepthManager;
	/**
	 * 拖动管理
	 * @author lyman
	 * 
	 */	
	public class DragManager
	{
		
		private static var _collectionMap:HashMap = new HashMap();
		
		public function DragManager():void
		{
			
		}
		
		public static function add(downTarget:InteractiveObject,moveTarget:Sprite):void
		{
			if(downTarget is Sprite)
			{
				(downTarget as Sprite).buttonMode = true;
			}
			downTarget.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			downTarget.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
			_collectionMap.add(downTarget,moveTarget);
		}
		
		private static function onMouseDownHandler(e:MouseEvent):void
		{
			var sp:Sprite = _collectionMap.getValue(e.currentTarget  as InteractiveObject) as Sprite;
			if(sp)
			{
				DepthManager.bringToTop(sp);
				sp.startDrag();
			}
		}
		private static function onMouseUpHandler(e:MouseEvent):void
		{
			var sp:Sprite = _collectionMap.getValue(e.currentTarget  as InteractiveObject) as Sprite;
			if(sp)
			{
				sp.stopDrag();
			}
		}
		public static function remove(downTarget:InteractiveObject):void
		{
			downTarget.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
			downTarget.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
			var sp:Sprite = _collectionMap.getValue(downTarget) as Sprite;
			if(sp)
			{
				_collectionMap.remove(downTarget);
				sp = null;
			}
		}
		
	}
}