package com.lilynumber1.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import com.lilynumber1.ds.HashMap;

	[Event(name="preDataChange", type = "fl.events.DataChangeEvent")]
	[Event(name="dataChange", type = "fl.events.DataChangeEvent")]
	
	/**
	 * 数据驱动
	 * @author tb
	 * 
	 */	
	public class HashMapProvider extends EventDispatcher
	{
		private var _data:HashMap = new HashMap();
		public var autoUpdate:Boolean = true;//启用/禁止广播事件
		
		public function HashMapProvider()
		{
			
		}
		
		//--------------------------------------------------
		// get set
		//--------------------------------------------------
		
		public function get length():uint
		{
			return _data.length;
		}
		
		//--------------------------------------------------
		// public
		//--------------------------------------------------
		
		/**
		 * 刷新 
		 * @return 
		 * 
		 */		
		public function refresh():void
		{
			dispatchChangeEvent(DataChangeType.RESET, _data.getValues());
		}
		
		/**
		 * 广播查询项，因为有可能需要从服务器查询，每个接口不一样，这里只提供广播数据
		 * @param ed 侦听广播的对象
		 * @param item
		 * 
		 */		
		public function dispatchSelect(ed:IEventDispatcher,key:*,value:*):void
		{
			_data.add(key,value);
			ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.SELECT, [value]));
		}
		
		/**
		 * 广播多个查询项，因为有可能需要从服务器查询，每个接口不一样，这里只提供广播数据
		 * @param ed 侦听广播的对象
		 * @param items
		 * 
		 */		
		public function dispatchSelectMulti(ed:IEventDispatcher,keys:Array,values:Array):void
		{
			var len:int = keys.length;
			for(var i:int=0;i<len;i++)
			{
				_data.add(keys[i],values[i]);
			}
			ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.SELECT, values.concat()));
		}
		
		/**
		 * 添加
		 * @param key
		 * @param value
		 * 
		 */			
		public function add(key:*,value:*):*
		{
			var old:* = _data.add(key,value);
			dispatchChangeEvent(DataChangeType.ADD, [value]);
			return old;
		}
		
		/**
		 * 添加多个项 
		 * @param keys
		 * @param values
		 * @return 
		 * 
		 */		
		public function addMulti(keys:Array,values:Array):Array
		{
			var arr:Array = [];
			var len:int = keys.length;
			for(var i:int=0;i<len;i++)
			{
				var old:* = _data.add(keys[i],values[i]);
				if(old)
				{
					arr.push(old);
				}
			}
			dispatchChangeEvent(DataChangeType.ADD, values.concat());
			return arr;
		}
		
		/**
		 * 移除 
		 * @param key
		 * @return 
		 * 
		 */	
		public function remove(key:*):*
		{
			var value:* = _data.remove(key);
			if(value)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, [value]);
				return value;
			}
			return null;
		}
		
		/**
		 * 移除多个项 
		 * @param keys
		 * @return 
		 * 
		 */		
		public function removeMulti(keys:Array):Array
		{
			var arr:Array = [];
			for each(var key:* in keys)
			{
				var value:* = _data.remove(key);
				if(value)
				{
					arr.push(value);
				}
			}
			if(arr.length > 0)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, arr.concat());
			}
			return arr;
		}
		
		/**
		 * 移除，参数是value
		 * @param value
		 * @return 
		 * 
		 */		
		public function removeForValue(value:*):*
		{
			var key:* = _data.getKey(value);
			if(key)
			{
				var v:* = _data.remove(key);
				if(v)
				{
					dispatchChangeEvent(DataChangeType.REMOVE, [v]);
					return v;
				}
			}
			return null;
		}
		
		/**
		 * 移除多个项，参数是value
		 * @param values
		 * @return 
		 * 
		 */		
		public function removeMultiForValue(values:Array):Array
		{
			var arr:Array = [];
			for each(var value:* in values)
			{
				var key:* = _data.getKey(value);
				if(key)
				{
					var v:* = _data.remove(key);
					if(v)
					{
						arr.push(v);
					}
				}
			}
			if(arr.length > 0)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, arr.concat());
			}
			return arr;
		}
		
		/**
		 * 移除全部
		 * 
		 */		
		public function removeAll():void
		{
			var arr:Array = _data.getValues();
			_data.clear();
			dispatchChangeEvent(DataChangeType.REMOVE_ALL, arr);
		}
		
		/**
		 * 更新项
		 * @param key
		 * @param newV
		 * 
		 */		
		public function upDateForKey(key:*,newV:*):void
		{
			if(_data.containsKey(key))
			{
				var oldV:* = _data.add(key,newV);
				if(oldV)
				{
					dispatchPreChangeEvent(DataChangeType.UPDATE, [oldV]);
				}
				dispatchChangeEvent(DataChangeType.UPDATE, [newV]);
			}
		}
		/**
		 * 更新项
		 * @param oldV
		 * @param newV
		 * 
		 */				
		public function upDateForValue(oldV:*,newV:*):void
		{
			var key:* = _data.getKey(oldV);
			if(key)
			{
				_data.add(key,newV);
				dispatchPreChangeEvent(DataChangeType.UPDATE, [oldV]);
				dispatchChangeEvent(DataChangeType.UPDATE, [newV]);
			}
		}
		
		public function toHashMap():HashMap
		{
			return _data.clone();
		}
		
		//--------------------------------------------------
		// HashMap 只为实现HashMap的API，无修改
		//--------------------------------------------------
		
		public function containsValue(value:*):Boolean
		{
			return _data.containsValue(value);
		}	
		public function containsKey(key:*):Boolean
		{
			return _data.containsKey(key);
		}	
		public function getValue(key:*):*
		{
			return _data.getValue(key);
		}		
		public function getKey(value:*):*
		{
			return _data.getKey(value);
		}
		public function getValues():Array
		{
			return _data.getValues();
		}
		public function getKeys():Array
		{
			return _data.getKeys();
		}
		
		//--------------------------------------------------
		// event
		//--------------------------------------------------
		
		protected function dispatchChangeEvent(evtType:String, items:Array):void
		{
			if(!autoUpdate)
			{
				return ;
			}
			if(hasEventListener(DataChangeEvent.DATA_CHANGE))
			{
				dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, evtType, items));
			}
		}
		
		protected function dispatchPreChangeEvent(evtType:String, items:Array):void
		{
			if(!autoUpdate)
			{
				return ;
			}
			if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
			{
				dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items));
			}
		}
	}

}