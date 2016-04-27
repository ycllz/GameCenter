package com.lilynumber1.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 位图播放器，由外部控制播放
	 * @author tb
	 * 
	 */	
	public class ExtBitmapPlayer extends Bitmap
	{
		private var _bitmapList:Array = [];//动作位图数据列表
		private var _totalFrames:uint;//总帧
		private var _currentFrame:uint;//当前帧
		
		public function ExtBitmapPlayer(dataList:Array=null)
		{
			if(dataList)
			{
				this.dataList = dataList;
			}
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
		
		public function set currentFrame(frame:uint):void
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
			bitmapData = _bitmapList[_currentFrame];
		}
		
		public function set dataList(value:Array):void
		{
			if(value == null)
			{
				clear();
				return ;
			}
			_bitmapList = value;
			_totalFrames = _bitmapList.length;
			_currentFrame = 0;
			bitmapData = _bitmapList[_currentFrame];
		}
		
		//--------------------------------------------------------------
		// public function
		//--------------------------------------------------------------
		
		public function nextFrame():void
		{
			if(_totalFrames > 1)
			{
				bitmapData = _bitmapList[_currentFrame];
				//
				_currentFrame++;
				if(_currentFrame == _totalFrames)
				{
					_currentFrame = 0;
				}
			}
		}
		
		/**
		 * 清空显示 
		 * 
		 */		
		public function clear():void
		{
			bitmapData = null;
			_totalFrames = 0;
			_currentFrame = 0;
			_bitmapList = [];
		}
		
		/**
		 * 
		 * @param gc 是否将引用的位图数据也销毁，默认为false
		 * 
		 */		
		public function destroy(gc:Boolean=false):void
		{
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
	}
}