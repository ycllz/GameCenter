package com.lilynumber1.ds
{
	import flash.utils.Dictionary;

	/**
	 * 双向哈希，高效的双向查找。通过value查找key的效率，跟通过key查找value的效率一样高，但是内存消耗比HashMap高
	 * @author tb
	 *
	 */
	public class DHash implements ICollection
	{
		private var _length:int;
		private var _contentKey:Dictionary;
		private var _contentValue:Dictionary;
		private var _weakKeys:Boolean;

		/**
		 * 构造函数
		 * @param weakKeys 是否是弱引用
		 *
		 */
		public function DHash(weakKeys:Boolean = false)
		{
			_weakKeys = weakKeys;
			_length = 0;
			_contentKey = new Dictionary(weakKeys);
			_contentValue = new Dictionary(weakKeys);
		}

		/**
		 * 当前DHash的长度
		 * @return
		 *
		 */
		public function get length():int
		{
			return _length;
		}

		/**
		 * 当前DHash是否为空
		 * @return
		 *
		 */
		public function isEmpty():Boolean
		{
			return _length == 0;
		}

		/**
		 * 获取Key列表
		 * @return
		 *
		 */
		public function getKeys():Array
		{
			var temp:Array = new Array(_length);
			var index:int = 0;
			var i:*;
			for each(i in _contentValue)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}

		/**
		 * 获取Value列表
		 * @return
		 *
		 */
		public function getValues():Array
		{
			var temp:Array = new Array(_length);
			var index:int = 0;
			var i:*;
			for each (i in _contentKey)
			{
				temp[index] = i;
				index++;
			}
			return temp;
		}

		/**
		 * 对Key列表中的每一项执行函数
		 * @param func
		 *
		 */
		public function eachKey(func:Function):void
		{
			var i:*;
			for each(i in _contentValue)
			{
				func(i);
			}
		}

		/**
		 * 对Value列表中的每一项执行函数
		 * @param func
		 *
		 */
		public function eachValue(func:Function):void
		{
			var i:*;
			for each (i in _contentKey)
			{
				func(i);
			}
		}

		/**
		 * 对整个DHash的每一项执行函数
		 * @param func 第一个参数是key,第二个参数是Value
		 *
		 */
		public function each2(func:Function):void
		{
			var i:*;
			for (i in _contentKey)
			{
				func(i, _contentKey[i]);
			}
		}

		/**
		 * 当前DHash是否有value
		 * @param value
		 * @return
		 *
		 */
		public function containsValue(value:*):Boolean
		{
			return (_contentValue[value] !== undefined);
		}

		/**
		 * 当前DHash是否有Key
		 * @param key
		 * @return
		 *
		 */
		public function containsKey(key:*):Boolean
		{
			return (_contentKey[key] !== undefined);
		}
		
		/**
		 * 当前DHash是否有key或value 
		 * @param kv
		 * @return 
		 * 
		 */		
		public function contains(kv:*):Boolean
		{
			if(_contentKey[kv] !== undefined)
			{
				return true;
			}
			if(_contentValue[kv] !== undefined)
			{
				return true;
			}
			return false;
		}

		/**
		 * 从指定的Key中获取 Value
		 * @param key
		 * @return
		 *
		 */
		public function getValue(key:*):*
		{
			var value:* = _contentKey[key];
			return value === undefined ? null : value;
		}

		/**
		 * 从指定的Value中获取Key
		 * @param value
		 * @return
		 *
		 */
		public function getKey(value:*):*
		{
			var key:* = _contentValue[value];
			return key === undefined ? null : key;
		}

		/**
		 * 添加key value，返回的是旧的key对应的value，如果没有则返回null
		 * @param key
		 * @param value
		 * @return
		 *
		 */
		public function addForKey(key:*, value:*):*
		{
			if (key == null)
			{
				throw new ArgumentError("cannot put a value with undefined or null key!");
				return null;
			}
			if(value === undefined)
			{
				return null;
			}
			else
			{
				if (_contentKey[key] === undefined)
				{
					_length++;
				}
				var oldValue:* = getValue(key);
				delete _contentValue[oldValue];
				_contentKey[key] = value;
				_contentValue[value] = key;
				return oldValue;
			}
		}
		
		/**
		 * 添加value key，返回的是旧的value对应的key，如果没有则返回null
		 * @param value
		 * @param key
		 * @return 
		 * 
		 */		
		public function addForValue(value:*, key:*):*
		{
			if (value == null)
			{
				throw new ArgumentError("cannot put a key with undefined or null value!");
				return null;
			}
			if(key === undefined)
			{
				return null;
			}
			else
			{
				if (_contentValue[value] === undefined)
				{
					_length++;
				}
				var oldKey:* = getKey(value);
				delete _contentKey[oldKey];
				_contentValue[value] = key;
				_contentKey[key] = value;
				return oldKey;
			}
		}

		/**
		 * 移除key value，返回的是旧的key对应的value，如果没有则返回null
		 * @param key
		 * @return
		 *
		 */
		public function removeForKey(key:*):*
		{
			if (_contentKey[key] !== undefined)
			{
				var value:* = _contentKey[key];
				delete _contentKey[key];
				delete _contentValue[value];
				_length--;
				return value;
			}
			return null;
		}
		
		/**
		 * 移除value key，返回的是旧的value对应的key，如果没有则返回null
		 * @param value
		 * @return 
		 * 
		 */		
		public function removeForValue(value:*):*
		{
			if (_contentValue[value] !== undefined)
			{
				var key:* = _contentValue[value];
				delete _contentValue[value];
				delete _contentKey[key];
				_length--;
				return key;
			}
			return null;
		}

		/**
		 * 清空当前 DHash
		 *
		 */
		public function clear():void
		{
			_length = 0;
			_contentKey = new Dictionary(_weakKeys);
			_contentValue = new Dictionary(_weakKeys);
		}

		/**
		 * 克隆当前 DHash
		 * @return
		 *
		 */
		public function clone():DHash
		{
			var temp:DHash = new DHash(_weakKeys);
			var i:*;
			for (i in _contentKey)
			{
				temp.addForKey(i, _contentKey[i]);
			}
			return temp;
		}
	}
}