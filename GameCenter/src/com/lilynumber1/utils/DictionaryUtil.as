package com.lilynumber1.utils
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author tb
	 * 
	 */	
	public class DictionaryUtil
	{
		
		/**
		 * 获取 Dictionary 里的Keys
		 * @param d
		 * @return 
		 * 
		 */						
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for (var key:Object in d)
			{
				a.push(key);
			}
			
			return a;
		}
		
		/**
		 * 获取 Dictionary 里的 Values
		 * @param d
		 * @return 
		 * 
		 */
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for each (var value:Object in d)
			{
				a.push(value);
			}
			
			return a;
		}
	}
}