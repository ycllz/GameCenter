package com.lilynumber1.utils
{
	/**
	 * 位功能
	 * @author tb
	 * 
	 */	
	public class BitUtil
	{
		/**
		 * 位位置 
		 */		
		public static const BIT_POS:Array = [0x01,0x02,0x04,0x08,
											0x10,0x20,0x40,0x80,
											0x100,0x200,0x400,0x800,
											0x1000,0x2000,0x4000,0x8000,
											0x10000,0x20000,0x40000,0x80000,
											0x100000,0x200000,0x400000,0x800000,
											0x1000000,0x2000000,0x4000000,0x8000000,
											0x10000000,0x20000000,0x40000000,0x80000000,];
		
		/**
		 * 获取一个整数的某一位值 
		 * @param byte
		 * @param index
		 * @return 
		 * 
		 */		
		public static function getBit(byte:uint,index:uint):uint
		{
			return (byte&BIT_POS[index])>>index;
		}
	}
}