package com.lilynumber1.tmf
{
	import flash.utils.Dictionary;

	/**
	 * Taomee Message Format
	 * 淘米传输信息格式化,对于未注册的类型，则返回ByteArray类型的原始数据
	 * @author tb
	 *
	 */
	public class TMF
	{
		private static var _map:Dictionary = new Dictionary();

		/**
		 * 注册类
		 * @param id
		 * @param cs
		 *
		 */
		public static function registerClass(id:uint, cs:Class):void
		{
			_map[id] = cs;
		}

		/**
		 * 移除注册的类
		 * @param id
		 *
		 */
		public static function removeClass(id:uint):void
		{
			delete _map[id];
		}

		/**
		 * 获取类
		 * @param id
		 * @return
		 *
		 */
		public static function getClass(id:uint):Class
		{
			if (_map[id] == null)
			{
				return TmfByteArray;
			}
			else
			{
				return _map[id];
			}
		}
	}
}