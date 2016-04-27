package com.lilynumber1.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 位图播放器，由自定义定时器控制
	 * @author tb
	 * 
	 */	
	public class BitmapPlayer extends Bitmap
	{
		private var _bitmapList:Array = [];//动作位图数据列表
		private var _totalFrames:uint;//总帧
		private var _currentFrame:uint;//当前帧
		//
		private var _currentCount:uint;//当前播放次数
		private var _repeatCount:uint;//总播放次数，默认为无限循环播放
		private var _timeID:uint;//超时进程的唯一数字标识符
		private var _delay:uint = 40;//播放频率
		private var _playing:Boolean;//是否正在播放
		
		public function BitmapPlayer(delay:uint=40,repeatCount:uint=0)
		{
			_delay = delay;
			_repeatCount = repeatCount;
		}
		
		//--------------------------------------------------------------
		// get set
		//--------------------------------------------------------------
		
		public function get totalFrames():uint
		{
			return _totalFrames;
		}
		
		public function get currentFrame():uint
		{
			return _currentFrame;
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		public function set dataList(value:Array):void
		{
			if(value == null)
			{
				clear();
				return ;
			}
			stop();
			_bitmapList = value;
			_totalFrames = _bitmapList.length;
			_currentFrame = 0;
			_currentCount = 0;
			bitmapData = _bitmapList[_currentFrame];
		}
		
		public function get repeatCount():uint
		{
			return _repeatCount;
		}
		public function set repeatCount(value:uint):void
		{
			_repeatCount = value;
		}
		
		public function get delay():uint
		{
			return _delay;
		}
		public function set delay(value:uint):void
		{
			_delay = value;
			clearInterval(_timeID);
			if(_totalFrames > 1)
			{
				_timeID = setInterval(onEnter,_delay);
			}
		}
		
		//--------------------------------------------------------------
		// public function
		//--------------------------------------------------------------
		
		public function play():void
		{
			_playing = true;
			clearInterval(_timeID);
			if(_totalFrames > 1)
			{
				_timeID = setInterval(onEnter,_delay);
			}
			onEnter();
		}
		public function stop():void
		{
			clearInterval(_timeID);
			_playing = false;
		}
		
		public function gotoAndPlay(frame:uint):void
		{
			if(frame>_totalFrames-1)
			{
				frame = _totalFrames-1;
			}
			if(frame < 0)
			{
				return ;
			}
			_currentFrame = frame;
			if(!_playing)
			{
				play();
			}
		}
		public function gotoAndStop(frame:uint):void
		{
			if(frame>_totalFrames-1)
			{
				frame = _totalFrames-1;
			}
			if(frame < 0)
			{
				return ;
			}
			stop();
			_currentFrame = frame;
			bitmapData = _bitmapList[_currentFrame];
		}
		
		/**
		 * 清空显示 
		 * 
		 */		
		public function clear():void
		{
			stop();
			bitmapData = null;
			_totalFrames = 0;
			_currentFrame = 0;
			_bitmapList = [];
			_currentCount = 0;
		}
		
		/**
		 * 
		 * @param gc 是否将引用的位图数据也销毁，默认为false
		 * 
		 */		
		public function destroy(gc:Boolean=false):void
		{
			stop();
			if(gc)
			{
				_bitmapList.forEach(function(item:*,index:int,array:Array):void
				{
					if(item)
					{
						item.dispose();
					}
				});
			}
			bitmapData = null;
			_bitmapList = null;
		}
		
		//--------------------------------------------------------------
		// private function
		//--------------------------------------------------------------
		
		private function onEnter():void
		{
			bitmapData = _bitmapList[_currentFrame];
			//
			_currentFrame++;
			if(_currentFrame == _totalFrames)
			{
				_currentFrame = 0;
				if(_repeatCount != 0)
				{
					_currentCount++;
					if(_currentCount == _repeatCount)
					{
						stop();
					}
				}
			}
		}
	}
}