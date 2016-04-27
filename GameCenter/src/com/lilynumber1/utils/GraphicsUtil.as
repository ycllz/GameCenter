package com.lilynumber1.utils
{
	import flash.display.Graphics;

	/**
	 * 绘画功能
	 * @author tb
	 *
	 */
	public class GraphicsUtil
	{
		/**
		 * 画扇形 
		 * @param target 绘画对象
		 * @param x 中心点X轴
		 * @param y 中心点Y轴
		 * @param startAngle 开始角度
		 * @param arc 大小
		 * @param radius 半径
		 * @param yRadius y轴半径，与radius不相等时为椭圆扇形
		 * 
		 */		
		public static function drawWedge(target:Graphics,x:Number,y:Number,startAngle:Number,arc:Number,radius:Number,yRadius:Number = NaN):void
		{
			target.moveTo(x,y);
			if(isNaN(yRadius))
			{
				yRadius = radius;
			}
			if(Math.abs(arc) > 360)
			{
				arc = 360;
			}
			
			var segs:int = Math.ceil(Math.abs(arc) / 45);
			var segAngle:Number = arc / segs;
			var theta:Number = -(segAngle / 180) * Math.PI;
			var angle:Number = -(startAngle / 180) * Math.PI;
			if(segs > 0)
			{
				var ax:Number = x + Math.cos(startAngle / 180 * Math.PI) * radius;
				var ay:Number = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
				target.lineTo(ax,ay);
				for(var i:int = 0;i < segs;i++)
				{
					angle += theta;
					var angleMid:Number = angle - (theta / 2);
					var bx:Number = x + Math.cos(angle) * radius;
					var by:Number = y + Math.sin(angle) * yRadius;
					var cx:Number = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
					var cy:Number = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
					target.curveTo(cx,cy,bx,by);
				}
				target.lineTo(x,y);
			}
		}

		public static function drawDashedLine(target:Graphics,xStart:Number,yStart:Number,xEnd:Number,yEnd:Number,dashSize:Number = 10,gapSize:Number = 10):void
		{
			var segmentLength:Number = dashSize + gapSize;
			var xDelta:Number = xEnd - xStart;
			var yDelta:Number = yEnd - yStart;
			var delta:Number = Math.sqrt(Math.pow(xDelta,2) + Math.pow(yDelta,2));
			var segmentCount:int = Math.floor(Math.abs(delta / segmentLength));
			var radians:Number = Math.atan2(yDelta,xDelta);
			var xCurrent:Number = xStart;
			var yCurrent:Number = yStart;
			xDelta = Math.cos(radians) * segmentLength;
			yDelta = Math.sin(radians) * segmentLength;
			for(var i:int = 0;i < segmentCount;i++)
			{
				target.moveTo(xCurrent,yCurrent);
				target.lineTo(xCurrent + Math.cos(radians) * dashSize,yCurrent + Math.sin(radians) * dashSize);
				xCurrent += xDelta;
				yCurrent += yDelta;
			}
			target.moveTo(xCurrent,yCurrent);
			delta = Math.sqrt((xEnd - xCurrent) * (xEnd - xCurrent) + (yEnd - yCurrent) * (yEnd - yCurrent));
			if(delta > dashSize)
			{
				target.lineTo(xCurrent + Math.cos(radians) * dashSize,yCurrent + Math.sin(radians) * dashSize);
			}
			else if(delta > 0)
			{
				target.lineTo(xCurrent + Math.cos(radians) * delta,yCurrent + Math.sin(radians) * delta);
			}
			target.moveTo(xEnd,yEnd);
		}
	}
}