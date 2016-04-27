package com.lilynumber1.utils
{
	/**
	 * 数组功能
	 * @author tb
	 * 
	 */		
	public class ArrayUtil
	{
				
		/**
		 * 判断数组里是否有该值 
		 * @param arr
		 * @param value
		 * @return 
		 * 
		 */					
		public static function arrayContainsValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}	
		
		/**
		 * 从数组中移除该值 
		 * @param arr
		 * @param value
		 * 
		 */		
		public static function removeValueFromArray(arr:Array, value:Object):void
		{
			var i:int = arr.indexOf(value);
			if(i!=-1){
				arr.splice(i, 1);
			}
		}

		/**
		 * 从数组中创建没有重复数据的数组 
		 * @param a
		 * @return 
		 * 
		 */		
		public static function createUniqueCopy(a:Array):Array
		{
			var uniqueArr:Array = [];
			a.forEach(function(item:Object,index:int,array:Array):void
			{
				if(uniqueArr.indexOf(item) == -1)
				{
					uniqueArr.push(item);
				}
			});
			return uniqueArr;
		}
		
		/**
		 * 复制数组，只能复制数组中是基本类型的数组 
		 * @param arr
		 * @return 
		 * 
		 */	
		public static function copyArray(arr:Array):Array
		{	
			return arr.slice();
		}
		
		/**
		 * 比较两个数组内容是否相等 
		 * @param arr1
		 * @param arr2
		 * @return 
		 * 
		 */		
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			//
			var isd:Boolean;
			isd = arr1.every(function(item:Object,index:int,array:Array):Boolean
			{
				if(arr2.indexOf(item) == -1)
				{
					return false;
				}
				return true;
			});
			if(!isd)
			{
				return false;
			}
			isd = arr2.every(function(item:Object,index:int,array:Array):Boolean
			{
				if(arr1.indexOf(item) == -1)
				{
					return false;
				}
				return true;
			});
			return isd;
		}
		
		/**
		 * 判断arr1是否都包含有arr2的内容。数学上的解析为：集合arr2是否属于集合arr1
		 * @return 
		 * 
		 */		
		public static function embody(arr1:Array,arr2:Array):Boolean
		{
			var isd:Boolean = arr2.every(function(item:Object,index:int,array:Array):Boolean
			{
				if(arr1.indexOf(item)==-1)
				{
					return false;
				}
				return true;
			});
			return isd;
		}
	}
}
