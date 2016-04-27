package com.lilynumber1.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import com.lilynumber1.ds.HashMap;
	import com.lilynumber1.utils.DisplayUtil;
	
	/**
	 * 工具提示管理
	 * @author tb
	 * 
	 */	
	public class ToolTipManager
	{
		
		
		private static var _toolTip:Sprite;
		private static var _txt:TextField;
		private static var _bitmapdata:BitmapData;
		private static var _bitmap:Bitmap;
		private static var _bg:DisplayObject;
		private static var _listMap:HashMap;
		private static var _cx:Number;
		private static var _cy:Number;
		private static var tf:TextFormat;
		
		public static function setup(bg:DisplayObject):void
		{
			_bg = bg;
			_listMap = new HashMap();
			_toolTip = new Sprite();
			_toolTip.mouseChildren = false;
			_toolTip.mouseEnabled = false;
			_toolTip.addChild(_bg);
			_txt = new TextField();
			_txt.width = 120;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_bitmap = new Bitmap();
			_toolTip.addChild(_bitmap);
			
			tf = new TextFormat();
			//tf.align = TextFormatAlign.CENTER;
		}
		
		public static function add(obj:InteractiveObject,str:String):void
		{
			obj.addEventListener(MouseEvent.ROLL_OVER,onOver);
			obj.addEventListener(MouseEvent.ROLL_OUT,onOut);
			_listMap.add(obj,str);
		}
		public static function remove(obj:InteractiveObject):void
		{
			if(_listMap.containsKey(obj)){
				obj.removeEventListener(MouseEvent.ROLL_OVER,onOver);
				obj.removeEventListener(MouseEvent.ROLL_OUT,onOut);
				_listMap.remove(obj);
			}
			onFinishTween();
		}
		
		//--------------------------------------------------
		// event
		//--------------------------------------------------
		
		private static function onOver(e:MouseEvent):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			_txt.htmlText = _listMap.getValue(obj);
			_txt.setTextFormat(tf);
			if(_bitmapdata)
			{
				_bitmapdata.dispose();
				_bitmapdata = null;
			}
			var w:Number = _txt.textWidth + 2;
			var h:Number = _txt.textHeight + 2;
			_bitmapdata = new BitmapData(w,h);
			_bitmapdata.draw(_txt);
			_bitmap.bitmapData = _bitmapdata;
			_bitmap.x = 2;
			_bitmap.y = 1;
			_bg.width = _bitmap.width+8;
			_bg.height = _bitmap.height+6;
			
			PopUpManager.showForMouse(_toolTip,PopUpManager.TOP_RIGHT,5,-5);
			_cx = _toolTip.x - e.stageX;
			_cy = _toolTip.y - e.stageY;
			LilyManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		private static function onOut(e:MouseEvent):void
		{
			onFinishTween();
			//TweenLite.to(_toolTip, 0.2, {alpha: 0, ease: Back.easeOut, onComplete: onFinishTween});
		}
		private static function onMove(e:MouseEvent):void
		{
			_toolTip.x = _cx + e.stageX;
			_toolTip.y = _cy + e.stageY; 
		}
		private static function onFinishTween():void
		{
			DisplayUtil.removeForParent(_toolTip);
			LilyManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
	}
}