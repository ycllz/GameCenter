package com.lilynumber1.ds
{
	import flash.utils.Dictionary;
	
	/**
	 * 哈希集 
	 * @author tb
	 * 
	 */	
	public class HashSet implements ICollection
	{
		private var _content:Dictionary;
		private var _length:int;
		private var _weakKeys:Boolean;
		
		public function HashSet(weakKeys:Boolean = false)
		{
			_weakKeys = weakKeys;
			_content = new Dictionary(weakKeys);
			_length = 0;
		}
		
		public function get length():int
		{
			return _length;
		}
		
		public function add(o:*):void
		{
			if(o === undefined)
			{
				return ;
			}
			if(_content[o] === undefined)
			{
				_length++;
			}
			_content[o] = o;
		}
		
		public function contains(o:*):Boolean
		{
			if (_content[o] === undefined)
			{
				return false;
			}
			return true;
		}
		
		public function isEmpty():Boolean
		{
			return _length == 0;
		}
		
		public function remove(o:*):Boolean
		{
			if(_content[o] !== undefined)
			{
				delete _content[o];
				_length--;
				return true;
			}
			return false;
		}
		
		public function clear():void
		{
			_content = new Dictionary(_weakKeys);
			_length = 0;
		}
		
		public function addAll(arr:Array):void
		{
			var i:*;
			for each(i in arr)
			{
				add(i);
			}
		}
		
		public function removeAll(arr:Array):void
		{
			var i:*;
			for each(i in arr)
			{
				remove(i);
			}
		}
		
		public function containsAll(arr:Array):Boolean
		{
			var len:int = arr.length;
			var i:int;
			for(i=0; i<len; i++)
			{
				if(_content[arr[i]] === undefined)
				{
					return false;
				}
			}
			return true;
		}
		
		public function each2(func:Function):void
		{
			var i:*;
			for each(i in _content)
			{
				func(i);
			}
		}
		
		public function toArray():Array
		{
			var arr:Array = new Array(_length);
			var index:int = 0;
			var i:*;
			for each(i in _content)
			{
				arr[index] = i;
				index ++;
			}
			return arr;
		}
		
		public function clone():HashSet
		{
			var csd:HashSet = new HashSet(_weakKeys);
			var o:*;
			for each(o in _content)
			{
				csd.add(o);
			}
			return csd;
		}
	}

}