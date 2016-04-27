package panel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.ApplicationDomain;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import gs.TweenLite;
	
	import manager.LayerManager;
	import manager.ModuleManager;
	import manager.popup.ModalType;
	
	import model.BaseViewModule;
	
	import com.lilynumber1.utils.DisplayUtil;
	
	public class JewelleryGamePanel extends BaseViewModule
	{
		public static const HIGHEST_SCORE:String = "highest_score";
		
		
		private var _map:Array;
		private var _maxValue:int;
		private var _currentScore:int;
		private var _started:Boolean;
		
		private var _numBmds:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		private var _effectPool:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		private var _so:SharedObject;
		override public function setup():void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("JewelleryGamePanelUI") as Class;
			setMainUI(new cls());
			_so = SharedObject.getLocal(HIGHEST_SCORE);
			var rect:Rectangle = _mainUI["cellContainer"]["cell_0_2"].getBounds(_mainUI["cellContainer"]["cell_0_2"]);
			for (var i:int = 0; i < 9; i++) 
			{
				_mainUI["cellContainer"]["cell_0_2"].gotoAndStop(i + 1);
				var bmd:BitmapData = new BitmapData(_mainUI["cellContainer"]["cell_0_2"].width, _mainUI["cellContainer"]["cell_0_2"].height, true, 0);
				bmd.draw(_mainUI["cellContainer"]["cell_0_2"], new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
				_numBmds.push(bmd);
			}
			
			_callBackModule = "JewelleryGameStartPanel";
			startHandle();
			responseHighestScore(null);
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					if(_mainUI["cellContainer"]["cell_" + i + "_" + j])
					{
						_mainUI["cellContainer"]["cell_" + i + "_" + j].buttonMode = true;
						_mainUI["cellContainer"]["cell_" + i + "_" + j].addEventListener(MouseEvent.CLICK, cellClickHandle);
					}
				}
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					if(_mainUI["cellContainer"]["cell_" + i + "_" + j])
					{
						_mainUI["cellContainer"]["cell_" + i + "_" + j].removeEventListener(MouseEvent.CLICK, cellClickHandle);
					}
				}
			}
		}
		
		override public function destroy():void
		{
			while(_effectPool.length)
			{
				_effectPool.pop();
			}
			super.destroy();
		}
		
		override protected function onClose(e:MouseEvent):void
		{
			if(_started)
			{
				ModuleManager.turnAppModule("Alert","加载……",{txt:"游戏中是否退出？",ok:quit});
			}
			else
			{
				super.onClose(e);
			}
		}
		
		private function responseHighestScore(event:Event):void
		{
			if(_so.data[HIGHEST_SCORE] != null){
				_mainUI["highScoreLabel"].text = _so.data[HIGHEST_SCORE] + "";
			}else{
				_mainUI["highScoreLabel"].text = "0";
			}
		}
		
		private function quit():void
		{
			super.onClose(null);	
			_so.data[HIGHEST_SCORE] = _currentScore;
			_so.flush();
		}
		
		private function showResultPanel():void
		{
			ModuleManager.turnAppModule("JewelleryGameOverPanel","正在加载……",{score:_currentScore,close:quit});
			_started = false;
		}
		
		private function startHandle():void
		{
			_map = [[0, 1, 1, 1, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [0, 0, 1, 0, 0]];
			_maxValue = 1;
			_currentScore = 0;
			
			for (var i:int = 0; i < _map.length; i++) 
			{
				var array:Array = _map[i];
				for (var j:int = 0; j < array.length; j++) 
				{
					if(_map[i][j] != 0)
					{
						_mainUI["cellContainer"]["cell_" + i + "_" + j].gotoAndStop(_map[i][j]);
					}
				}
			}
		}
		
		private function cellClickHandle(event:MouseEvent):void
		{
			if(!_started)
			{
				return;
			}
			var name:String = event.currentTarget.name;
			var array:Array = name.split("_");
			var i:int = int(array[1]);//行索引
			var j:int = int(array[2]);//列索引
			var sameValues:Array = getSameCells(i, j, [i * 5 + j]);
			var length:int = sameValues.length;
			if(length >= 3)
			{
				var newValue:int = _map[i][j] + (length > 8 ? 2 : 1);
				if(newValue > _maxValue)
				{
					_maxValue = newValue;
				}
				addScore(Math.pow(3, newValue - 2));
				
				_map[i][j] = newValue;
				_mainUI["cellContainer"]["cell_" + i + "_" + j].gotoAndStop(newValue);
				
				sameValues.shift();
				
				for (var k:int = 0; k < length - 1; k++) 
				{
					i = int(sameValues[k] / 5);
					j = int(sameValues[k] % 5);
					
					var effect:Bitmap = getNewEffect();
					effect.alpha = 1;
					effect.bitmapData = _numBmds[_map[i][j] - 1];
					effect.x = _mainUI["cellContainer"]["cell_" + i + "_" + j].x;
					effect.y = _mainUI["cellContainer"]["cell_" + i + "_" + j].y;
					_mainUI["cellContainer"].addChild(effect);
					TweenLite.to(effect, 0.5, {alpha:0, x:event.currentTarget.x - effect.width * 0.5, y:event.currentTarget.y - effect.height * 0.5, onComplete:effectEndHandle, onCompleteParams:[effect]});
					
					//要加随机
					_map[i][j] = getRandomValue(_maxValue > 4 ? 3 : 2);
					_mainUI["cellContainer"]["cell_" + i + "_" + j].gotoAndStop(_map[i][j]);
				}
				
				
				for (i = 0; i < 5; i++) 
				{
					for (j = 0; j < 5; j++) 
					{
						if(getSameCells(i, j, [i * 5 + j]).length >= 3)
						{
							return;
						}
					}
				}
				showResultPanel();
			}
		}
		
		private function effectEndHandle(effect:Bitmap):void
		{
			effect.bitmapData = null;
			DisplayUtil.removeForParent(effect);
			_effectPool.push(effect);
		}
		
		private function effectRunning(event:Event):void
		{
			var effect:MovieClip = event.currentTarget as MovieClip;
			if(effect.currentFrame == effect.totalFrames)
			{
				effect.gotoAndStop(1);
				DisplayUtil.removeForParent(effect);
				_effectPool.push(effect);
			}
		}
		
		private function addScore(value:int):void
		{
			_currentScore += value;
			_mainUI["currentScoreLabel"].text = _currentScore + "";
			var score:int = 0;
			if(_so.data[HIGHEST_SCORE] != null){
				score = _so.data[HIGHEST_SCORE];
			}
			if(_currentScore > score)
			{
				_mainUI["highScoreLabel"].text = _currentScore + "";
			}
		}
		
		private function getNewEffect():Bitmap
		{
			if(_effectPool.length)
			{
				return _effectPool.pop();
			}
			return new Bitmap();
		}
		
		private function getRandomValue(maxValue:int):int
		{
			var random:int = Math.random() * 100;
			if(random < 10)
			{
				return 2;
			}
			else if(random < 12 && maxValue >= 3)
			{
				return 3;
			}
			else
			{
				return 1;
			}
		}
		
		private function getSameCells(i:int, j:int, includedCell:Array):Array
		{
			var cellValue:int = _map[i][j];
			var k:int;
			var m:int;
			
			//左
			k = i - 1;
			m = j;
			if(k >= 0 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
			{
				includedCell.push(k * 5 + m);
				getSameCells(k, m, includedCell);
			}
			//右
			k = i + 1;
			m = j;
			if(k <= 4 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
			{
				includedCell.push(k * 5 + m);
				getSameCells(k, m, includedCell);
			}
			//上
			k = i;
			m = j - 1;
			if(m >= 0 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
			{
				includedCell.push(k * 5 + m);
				getSameCells(k, m, includedCell);
			}
			//下
			k = i;
			m = j + 1;
			if(m <= 4 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
			{
				includedCell.push(k * 5 + m);
				getSameCells(k, m, includedCell);
			}
			if(j & 1)
			{
				//右上
				k = i + 1;
				m = j - 1;
				if(k <= 4 && m >= 0 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
				{
					includedCell.push(k * 5 + m);
					getSameCells(k, m, includedCell);
				}
				//右下
				k = i + 1;
				m = j + 1;
				if(k <= 4 && m <= 4 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
				{
					includedCell.push(k * 5 + m);
					getSameCells(k, m, includedCell);
				}
			}
			else
			{
				//左上
				k = i - 1;
				m = j - 1;
				if(k >= 0 && m >= 0 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
				{
					includedCell.push(k * 5 + m);
					getSameCells(k, m, includedCell);
				}
				//左下
				k = i - 1;
				m = j + 1;
				if(k >= 0 && m <= 4 && _map[k][m] == cellValue && includedCell.indexOf(k * 5 + m) == -1)
				{
					includedCell.push(k * 5 + m);
					getSameCells(k, m, includedCell);
				}
			}
			
			return includedCell;
		}
		
		override public function show():void
		{
			_modalType = ModalType.DARK;
			showFor(LayerManager.topLevel);
			_started = true;
		}
	}
}