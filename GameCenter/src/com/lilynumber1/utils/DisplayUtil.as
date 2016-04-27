package com.lilynumber1.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.lilynumber1.manager.LilyManager;

	/**
	 * 显示对象功能
	 * @author tb
	 *
	 */
	public class DisplayUtil
	{

		/**
		 * 停止一个容器里的所有MovieClip,如果当前容器是MovieClip，也停止
		 * @param dis
		 *
		 */
		public static function stopAllMovieClip(dis:DisplayObjectContainer,frame:uint = 0):void
		{
			var mc:MovieClip = dis as MovieClip;
			if (mc != null)
			{
//				mc.stop();
				mc = null;
			}
			var num:int = dis.numChildren - 1;
			if (num < 0)
			{
				return;
			}
			var child:DisplayObjectContainer;
			for (var i:int = num; i >= 0; i--)
			{
				child = dis.getChildAt(i) as DisplayObjectContainer;
				if (child != null)
				{
					stopAllMovieClip(child);
				}
			}
		}

		/**
		 * 移除容器里的所有显示对象
		 * @param dis
		 *
		 */
		public static function removeAllChild(dis:DisplayObjectContainer):void
		{
			var child:DisplayObjectContainer;
			while (dis.numChildren > 0)
			{
				child = dis.removeChildAt(0) as DisplayObjectContainer;
				if (child != null)
				{
					stopAllMovieClip(child);
					child = null;
				}

			}
		}

		/**
		 * 从该显示对象的父级移除该显示对象
		 * @param dis
		 *
		 */
		public static function removeForParent(dis:DisplayObject,gc:Boolean = true):void
		{
			if(dis == null)
			{
				return;
			}
			if (dis.parent == null)
			{
				return ;
			}
			if(!dis.parent.contains(dis))
			{
				return ;
			}
			if(gc)
			{
				var disc:DisplayObjectContainer = dis as DisplayObjectContainer;
				if(disc)
				{
					stopAllMovieClip(disc);
					disc = null;
				}
			}
			dis.parent.removeChild(dis);
		}
		
		public static function hasParent(target:DisplayObject):Boolean
		{
			if (target.parent == null)
			{
				return false;
			}
			return target.parent.contains(target);
		}

		public static function localToLocal(from:DisplayObject, _to:DisplayObject, p:Point = null):Point
		{
			if (p == null)
			{
				p = new Point(0, 0);
			}
			p = from.localToGlobal(p);
			p = _to.globalToLocal(p);
			return p;
		}

		/**
		 * 对齐
		 * @param target
		 * @param bounds
		 * @param align
		 * @param offset
		 *
		 */
		public static function align(target:DisplayObject, bounds:Rectangle = null, align:int = 0, offset:Point = null):void
		{
			if (bounds == null)
			{
				bounds = new Rectangle(0,0,LilyManager.stageWidth,LilyManager.stageHeight);
			}
			if (offset)
			{
				bounds.offsetPoint(offset);
			}
			var targetRect:Rectangle = target.getRect(target);
			var _hd:Number = bounds.width - target.width;
			var _vd:Number = bounds.height - target.height;
			switch (align)
			{
				case AlignType.TOP_LEFT:
					target.x = bounds.x;
					target.y = bounds.y;
					break;
				case AlignType.TOP_CENTER:
					target.x = bounds.x + _hd / 2 - targetRect.x;
					target.y = bounds.y;
					break;
				case AlignType.TOP_RIGHT:
					target.x = bounds.x + _hd - targetRect.x;
					target.y = bounds.y;
					break;
				case AlignType.MIDDLE_LEFT:
					target.x = bounds.x;
					target.y = bounds.y + _vd / 2 - targetRect.x;
					break;
				case AlignType.MIDDLE_CENTER:
					target.x = bounds.x + _hd / 2 - targetRect.x;
					target.y = bounds.y + _vd / 2 - targetRect.y;
					break;
				case AlignType.MIDDLE_RIGHT:
					target.x = bounds.x + _hd - targetRect.x;
					target.y = bounds.y + _vd / 2 - targetRect.y;
					break;
				case AlignType.BOTTOM_LEFT:
					target.x = bounds.x;
					target.y = bounds.y + _vd - targetRect.y;
					break;
				case AlignType.BOTTOM_CENTER:
					target.x = bounds.x + _hd / 2 - targetRect.x;
					target.y = bounds.y + _vd - targetRect.y;
					break;
				case AlignType.BOTTOM_RIGHT:
					target.x = bounds.x + _hd - targetRect.x;
					target.y = bounds.y + _vd - targetRect.y;
					break;
			}
		}

		/**
		 * 给显示对象填充颜色
		 * @param dis
		 * @param c
		 *
		 */
		public static function FillColor(target:DisplayObject, c:uint):void
		{
			var ctf:ColorTransform = new ColorTransform();
			ctf.color = c;
			target.transform.colorTransform = ctf;
		}
		
//		/**
//		 * 获取显示对象指定位置的颜色 
//		 * @param src
//		 * @param x
//		 * @param y
//		 * @param getAlpha
//		 * @return 
//		 * 
//		 */		
//		public static function getColor(target:DisplayObject, x:uint = 0, y:uint = 0, getAlpha:Boolean = false):uint
//		{
//			var bmp:BitmapData = new BitmapData(target.width, target.height);
//			bmp.draw(target);
//			var color:uint = (!getAlpha) ? bmp.getPixel(int(x), int(y)) : bmp.getPixel32(int(x), int(y));
//			bmp.dispose();
//			return color;
//		}
		
		/**
		 * 等比缩放指定大小 
		 * @param target
		 * @param num
		 * 
		 */		
		public static function uniformScale(target:DisplayObject,num:Number):void
		{
			if(target.width >= target.height)
			{
				target.width = num;
				target.scaleY = target.scaleX;
			}
			else
			{
				target.height = num;
				target.scaleX = target.scaleY;
			}
		}
		/**
		 * 将显示对象用bitmapdata draw成一张位图，返回的位图坐标与原先的display对象内部元素的X，Y坐标相同
		 * @return 
		 * 
		 */		
		public static function copyDisplayAsBmp(dis:DisplayObject,smoothing:Boolean = true):Bitmap
		{
			var oldX:Number;
			var oldY:Number;
			
			oldY = dis.scaleY;
			oldX = dis.scaleX;
			
			var bmpdata:BitmapData=new BitmapData(dis.width,dis.height,true,0);
			var rect:Rectangle=dis.getRect(dis);
			var matrix:Matrix = new Matrix();
			//matrix.translate(-rect.x,-rect.y);
			if(oldX <0)
				dis.scaleX = -dis.scaleX;
			if(oldY <0)
				dis.scaleY = -dis.scaleY;
			matrix.createBox(dis.scaleX,dis.scaleY,0,-rect.x*dis.scaleX,-rect.y*dis.scaleY);
			bmpdata.draw(dis,matrix);
			
			dis.scaleX = oldX;
			dis.scaleY = oldY;
			
			var bmp:Bitmap=new Bitmap(bmpdata,PixelSnapping.AUTO,smoothing);
			if(oldX < 0)
				bmp.scaleX = -1;
			if(oldY < 0)
				bmp.scaleY = -1;
			bmp.x=rect.x*dis.scaleX;
			bmp.y=rect.y*dis.scaleY;
			return bmp;
		}
		
		private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK,
														MouseEvent.DOUBLE_CLICK,
														MouseEvent.MOUSE_DOWN,
														MouseEvent.MOUSE_MOVE,
														MouseEvent.MOUSE_OUT,
														MouseEvent.MOUSE_OVER,
														MouseEvent.MOUSE_UP,
														MouseEvent.MOUSE_WHEEL,
														MouseEvent.ROLL_OUT,
														MouseEvent.ROLL_OVER];
		/**
		 * 禁止所有没有鼠标事件侦听的对象接收鼠标消息
		 * @param target
		 * 
		 */		
		public static function mouseEnabledAll(target:InteractiveObject):void
		{
			var b:Boolean = MOUSE_EVENT_LIST.some(function(item:String,index:int,array:Array):Boolean
			{
				if(target.hasEventListener(item))
				{
					return true;
				}
				return false;
			});
			if(!b)
			{
				target.mouseEnabled = false;
			}
			//
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			if(container)
			{
				var i:int = container.numChildren-1;
				var child:InteractiveObject;
				for (i; i >= 0; i--)
				{
					child = container.getChildAt(i) as InteractiveObject;
					if (child)
					{
						mouseEnabledAll(child);
					}
				}
			}
		}
	}
}