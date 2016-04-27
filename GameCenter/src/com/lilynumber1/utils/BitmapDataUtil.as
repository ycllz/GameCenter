package com.lilynumber1.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图数据功能 
	 * @author tb
	 * 
	 */	
	public class BitmapDataUtil
	{
		/**
		 * 截图一张位图，生成指定大小的位图数据列表 
		 * @param data 源位图数据
		 * @param width 宽
		 * @param height 高
		 * @param totalFrames 总帧数
		 * @param gc 是否消耗源位图数据
		 * @return 
		 * 
		 */		
		public static function makeList(data:BitmapData,width:int,height:int,totalFrames:uint,gc:Boolean=false):Array
		{
			var wLen:int = int(Math.min(data.width,2880)/width);
			var hLen:int = int(Math.min(data.height,2880)/height);
			//
			var iw:int;
			var ih:int;
			var count:int = 0;
			var bm:BitmapData;
			var arr:Array = [];
			var rect:Rectangle = new Rectangle(0,0,width,height);
			var pos:Point = new Point();
			
			for(ih = 0;ih<hLen;ih++)
			{
				for(iw = 0;iw<wLen;iw++)
				{
					if(count >= totalFrames)
					{
						return arr;
					}
					//
					rect.x = iw*width;
					rect.y = ih*height;
					bm = new BitmapData(width,height);
					bm.copyPixels(data,rect,pos);
					arr[count] = bm;
					count++;
				}
			}
			if(gc)
			{
				data.dispose();
			}
			return arr;
		}
	}
}