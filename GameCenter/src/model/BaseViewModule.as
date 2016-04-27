package model
{
	import data.AlignInfo;
	import data.GlobalEvent;
	import data.PanelType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.TweenLite;
	
	import manager.LayerManager;
	import manager.ModuleManager;
	import manager.popup.ModalType;
	import manager.popup.PopUpManager;
	
	import com.lilynumber1.module.IDisplayModule;
	import com.lilynumber1.utils.AlignType;
	import com.lilynumber1.utils.DisplayUtil;
	
	/**
	 * 基本显示模块 
	 */	
	public class BaseViewModule extends Sprite implements IDisplayModule
	{
		public static const AWARD_BTN:String = "awardBtn";
		protected var _type:int = PanelType.DESTROY;
		protected var _mainUI:Sprite;
		private var _dragBtn:SimpleButton;
		protected var _closeBtn:SimpleButton;
		protected var _tweenStartPoint:Point;
		protected var _tweenEndPoint:Point;
		protected var _callBackModule:String;
		
		private var _triggerPosition:AlignInfo;
		protected var _fadeIn:Boolean;
		protected var _fadeOut:Boolean;
		protected var _modalType:int = ModalType.NONE;
		
		private var _isCanOperate:Boolean = true;
		 
		protected function setMainUI(mainUI:Sprite):void
		{
			_mainUI = mainUI;
			if (_mainUI.hasOwnProperty("dragBtn"))
			{
				_dragBtn = _mainUI["dragBtn"];
			}
			if (_mainUI.hasOwnProperty("closeBtn"))
			{
				_closeBtn = _mainUI["closeBtn"];
			}
		}
		
		protected function showFor(parent:DisplayObjectContainer = null):void
		{
			if(parent == null)
			{
				parent = LayerManager.topLevel;
			}
			PopUpManager.instance.catchScreen(this);//必须在加之前截取
			parent.addChild(_mainUI);
			PopUpManager.instance.add(this);
			layout();
			dispatchEvent(new GlobalEvent(GlobalEvent.SHOW));
			addEvent();
			
			showEffectStart();
		}
		
		protected function showEffectStart() : void
		{
			if(_triggerPosition || _fadeIn)
			{
				var rect:Rectangle = _mainUI.getBounds(_mainUI);
				var bmd:BitmapData = new BitmapData(_mainUI.width, _mainUI.height, true, 0);
				bmd.draw(_mainUI, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
				var mirror:Bitmap = new Bitmap(bmd);
				
				if(_triggerPosition)
				{
					mirror.x = AlignInfo.getXPosition(LayerManager.stageWidth, 0, _triggerPosition);
					mirror.y = AlignInfo.getYPosition(LayerManager.stageHeight, 0, _triggerPosition);
					mirror.scaleX = mirror.scaleY = 0;
					_mainUI.visible = false;
					TweenLite.to(mirror, 0.3, {scaleX:1, scaleY:1, x:_mainUI.x + rect.left, y:_mainUI.y + rect.top, onComplete:onShowEffectCompelte, onCompleteParams:[mirror]});
				}
				else
				{
					mirror.x = _mainUI.x + rect.left;
					mirror.y = _mainUI.y + rect.top;
					mirror.alpha = 0;
					TweenLite.to(mirror, 0.5, {alpha:1, onComplete:onShowEffectCompelte, onCompleteParams:[mirror]});
				}
				
				LayerManager.topLevel.addChild(mirror);
			}
			else
			{
				showEffectComplete();
			}
		}
		
		private function onShowEffectCompelte(mirror:Bitmap):void
		{
			DisplayUtil.removeForParent(mirror);
			mirror.bitmapData.dispose();
			showEffectComplete();
		}
		
		protected function showEffectComplete() : void
		{
			if (_mainUI)
			{
				_mainUI.visible = true;
			}
		}
		
		protected function hideEffectStart() : void
		{
			if(_triggerPosition || _fadeOut)
			{
				if (!_mainUI)
				{
					return;
				}
				if(_mainUI.width > 8191  || _mainUI.height > 8191 || _mainUI.width * _mainUI.height > 16777215)
				{
					hideEffectComplete();
					return;
				}
				var rect:Rectangle = _mainUI.getBounds(_mainUI);
				var bmd:BitmapData = new BitmapData(_mainUI.width, _mainUI.height, true, 0);
				bmd.draw(_mainUI, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
				var mirror:Bitmap = new Bitmap(bmd);
				mirror.x = _mainUI.x + rect.left;
				mirror.y = _mainUI.y + rect.top;
				_mainUI.visible = false;
				
				if(_triggerPosition)
				{
					TweenLite.to(mirror, 0.3, {scaleX:0, scaleY:0, 
						x:AlignInfo.getXPosition(LayerManager.stageWidth, 0, _triggerPosition),
						y:AlignInfo.getYPosition(LayerManager.stageHeight, 0, _triggerPosition), onComplete:onHideEffectCompelte, onCompleteParams:[mirror]});
				}
				else
				{
					TweenLite.to(mirror, 0.5, {alpha:0, onComplete:onHideEffectCompelte, onCompleteParams:[mirror]});
				}
				LayerManager.topLevel.addChild(mirror);
			}
			else
			{
				hideEffectComplete();
			}
		}
		
		private function onHideEffectCompelte(mirror:Bitmap):void
		{
			DisplayUtil.removeForParent(mirror);
			mirror.bitmapData.dispose();
			hideEffectComplete();
		}
		
		protected function hideEffectComplete() : void
		{
		}
		
		protected function layout():void
		{
			if(_mainUI && _mainUI.parent)
			{
				_mainUI.x = LayerManager.MAX_WIDTH - _mainUI.width >> 1;
				_mainUI.y = LayerManager.MAX_HEIGHT - _mainUI.height >> 1;
			}
		}
		
		override public function set width(value:Number):void
		{
			_mainUI.width = value;
		}
		override public function get width():Number
		{
			return _mainUI.width;
		}
		override public function set height(value:Number):void
		{
			_mainUI.height = value;
		}
		override public function get height():Number
		{
			return _mainUI.height;
		}
		
		//--------------------------------------------------------
		// public function
		//--------------------------------------------------------
		
		public function setup():void
		{
		}
		
		public function init(data:Object=null):void
		{
			if(data && data["callBackModule"])
			{
				_callBackModule = data["callBackModule"];
			}
			if(data && data["triggerPosition"])
			{
				_triggerPosition = data["triggerPosition"];
			}
			if(data && data["fadeIn"])
			{
				_fadeIn = data["fadeIn"];
			}
			if(data && data["fadeOut"])
			{
				_fadeOut = data["fadeOut"];
			}
			if(data && data["modalType"])
			{
				_modalType = data["modalType"];
			}
		}
		
		public function show():void
		{
			showFor(LayerManager.topLevel);
		}
		
		public function get sprite():Sprite
		{
			return _mainUI;
		}
		
		public function get parentContainer():DisplayObjectContainer
		{
			return _mainUI.parent;
		}
		
		public function hide():void
		{
			PopUpManager.instance.remove(this);
			removeEvent();
			if(_mainUI)
			{
				_mainUI.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
				DisplayUtil.removeForParent(_mainUI,false);
			}
			dispatchEvent(new GlobalEvent(GlobalEvent.HIDE));
		}
		
		public function destroy():void
		{
			PopUpManager.instance.remove(this);
			removeEvent();
			if(_mainUI)
			{
				_mainUI.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
				DisplayUtil.removeForParent(_mainUI,true);
			}
			
			_dragBtn = null;
			_closeBtn = null;
			_mainUI = null;
			dispatchEvent(new GlobalEvent(GlobalEvent.DESTROY));
			if(_callBackModule)
			{
				ModuleManager.showModule(_callBackModule,"正在加载");
			}
		}
		
		public function get modalType():int
		{
			return _modalType;
		}
		
		//--------------------------------------------------------
		// private function
		//--------------------------------------------------------
		
		protected function addEvent():void
		{
			if(_closeBtn)
			{
				_closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(_dragBtn)
			{
				_dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDragDown);
//				_dragBtn.addEventListener(MouseEvent.MOUSE_UP, onDragUp);
			}
		}
		
		protected function removeEvent():void
		{
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK, onClose);
			}
			if(_dragBtn)
			{
				_dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDragDown);
//				_dragBtn.removeEventListener(MouseEvent.MOUSE_UP, onDragUp);
				LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUp);
			}
		}
		
		protected function removeCloseEvent():void
		{
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK, onClose);
			}
		}
		
		//--------------------------------------------------------
		// event
		//--------------------------------------------------------
		private function getSimpleBtn(con:DisplayObjectContainer,name:String):SimpleButton{
			return con.getChildByName(name) as SimpleButton;
		}
		private function onDragDown(e:MouseEvent):void
		{
			_mainUI.startDrag();
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP, onDragUp);
		}
		
		private function onDragUp(e:MouseEvent):void
		{
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUp);
			_mainUI.stopDrag();
		}

		protected function onClose(e:MouseEvent):void
		{
			hideEffectStart();
			if(_type == PanelType.HIDE)
			{
				hide();
			}
			else if(_type == PanelType.DESTROY)
			{
				destroy();
			}
		}
		
		private function onRemoveStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
		}
		
		protected function getTargetDailyId(targetName:String):int
		{
			if(targetName.indexOf(AWARD_BTN) != -1)
			{
				return getSplitId(targetName);
			}
			return 0;
		}
		
		protected function getSplitId(str:String):int
		{
			var arr:Array = str.split("_");
			if(arr.length == 2)
			{
				return arr[1];
			}
			return 0;
		}

		public function get isCanOperate():Boolean
		{
			return _isCanOperate;
		}

		public function set isCanOperate(value:Boolean):void
		{
			_isCanOperate = value;
		}

	}
}