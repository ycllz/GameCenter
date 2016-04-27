package com.lilynumber1.utils
{
	/**
	 * 数学功能 
	 * @author tb
	 * 
	 */	
	public class MathUtil
	{
		/**
		 * 指定范围随机数 
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function randomRegion(start:Number,end:Number):Number
		{
			return start+Math.random()*(end-start);
		}
		
		/**
		 * 减半数范围随机数，如果参数是6，则随机范围是3~6
		 * @param v
		 * @return 
		 * 
		 */		
		public static function randomHalve(v:Number):Number
		{
			return v-Math.random()*(v/2);
		}
		
		/**
		 * 加半数范围随机数，如果参数是6，则随机范围是6~9
		 * @param v
		 * @return 
		 * 
		 */		
		public static function randomHalfAdd(v:Number):Number
		{
			return v+Math.random()*(v/2);
		}
		
		/**
		 * 上下限值
		 */
		public static function clamp(n:Number, min:Number, max:Number):Number
		{
			if (n < min)
			{
				return min;
			}
			if (n > max)
			{
				return max;
			}
			return n;
		}
	}
}