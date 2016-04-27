package manager.loading
{
	import data.WordConfig;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import manager.LayerManager;
	import manager.StageResizeController;
	
	import com.lilynumber1.utils.AlignType;
	import com.lilynumber1.utils.DisplayUtil;

	/**
	 * 含有标题和百分比进度条的loading样式
	 */
	public class TitlePercentLoading extends TitleOnlyLoading implements ILoading
	{
		private static const KEY:String = "titlePercentLoading";
		private var _bgMC:MovieClip;
		private var _barWidth:Number;
		private var _rect:Rectangle;
		private var _tipTxt:TextField;
		private var _timer:Timer;
		private var _tips:Array;

		private var _prevChangeTime:int = 0;
		private var _currentFrame:int = 1;
		
		
		/**
		 * constructor
		 * @param KEY 库中对应的链接ID
		 *
		 */
		public function TitlePercentLoading(parent:DisplayObjectContainer,title:String = "Loading...",showCloseBtn:Boolean = false)
		{
			super(parent,title,showCloseBtn);
			_tipTxt = loadingBar["tip_txt"];
			_bgMC = loadingBar["bgMC"];
			if(_bgMC)
			{
				var frame:uint = uint(Math.random() * 2) + 1;
				_bgMC.gotoAndStop(frame);
			}
			_barWidth = _percentBar.width;
			_rect = new Rectangle(0,0,0,_percentBar.height);
			//
			_tips = getTips();
			if(_tips.length > 0)
			{
				onChangeTip(null);
				_timer = new Timer(2000);
				_timer.addEventListener(TimerEvent.TIMER,onChangeTip);
				_timer.start();
			}
		}
		protected function getTips():Array
		{
			return WordConfig.loading.concat();
		}

		private function onChangeTip(e:TimerEvent):void
		{
			if(_tips)
			{
				var num:uint = Math.floor(Math.random() * _tips.length);
				_tipTxt.text = _tips[num];
			}
		}

		/**
		 * 改变百分比
		 * @param total 总共的字节
		 * @param loaded 已加载的字节
		 *
		 */
		override public function setPercent(loaded:Number,total:Number):void
		{
			super.setPercent(loaded,total);
			_percentText.text = _percent + "%";
			_rect.width = _barWidth * (_percent / 100);
			_percentBar.scrollRect = _rect;
		}
		
		override public function show():void
		{
			super.show();
			
			var time:int = getTimer();
			if(time - _prevChangeTime > 5000)
			{
				_prevChangeTime = time;
				_currentFrame = int(Math.random() * _loadingBar.totalFrames) + 1;
			}
			_loadingBar.gotoAndStop(_currentFrame);
			
			layout();
			StageResizeController.instance.register(layout);
		}
		
		override public function hide():void
		{
			super.hide();
			StageResizeController.instance.unregister(layout);
		}
		
		private function layout():void
		{
			_loadingBar.x = LayerManager.stageWidth - LayerManager.MAX_WIDTH >> 1;
			_loadingBar.y = (LayerManager.stageHeight - LayerManager.MAX_HEIGHT) * .5;
//			DisplayUtil.align(_loadingBar, null, AlignType.MIDDLE_CENTER, new Point(0, -20));
		}

		/**
		 * 设置标题
		 * @param str
		 *
		 */
		override public function set title(str:String):void
		{
			super.title = str;
		}

		/**
		 * 关闭loading
		 *
		 */
		override public function destroy():void
		{
			StageResizeController.instance.unregister(layout);
			_percentText = null;
			_percentBar = null;
			_rect = null;
			_tipTxt = null;
			if(_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,onChangeTip);
			}
			_timer = null;
			super.destroy();
		}

		override public function get key():String
		{
			return KEY;
		}
	}
}