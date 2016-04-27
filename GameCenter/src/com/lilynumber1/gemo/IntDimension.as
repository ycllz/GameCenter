package com.lilynumber1.gemo
{
	/**
	 * 类似point记录一个点。该类记录一个尺寸，并且都是int型
	 * @author pig.hong
	 * 
	 */	
	public class IntDimension
	{
		private var _width:int = 0;
		private var _height:int = 0;
		
		public function IntDimension(w:int = 0,h:int = 0)
		{
			_width = w;
			_height = h;
		}
		
		//---------------------------------------
		//
		// public methods
		//
		//---------------------------------------
		
		public function setSize(dim:IntDimension):void
		{
			_width = dim.width;
			_height = dim.height;
		}
		public function setSizeWH(w:int,h:int):void
		{
			_width = w;
			_height = h;
		}
		
		//---------------------------------------
		//
		// getter and setter
		//
		//---------------------------------------
		public function get width():int
		{
			return _width;
		}
		public function get height():int
		{
			return _height;
		}
		public function set width(i:int):void
		{
			_width = i;
		}
		public function set height(i:int):void
		{
			_height = i;
		}
		
	}
}