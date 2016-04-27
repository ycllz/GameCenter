package com.lilynumber1.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="preDataChange", type = "fl.events.DataChangeEvent")]
	[Event(name="dataChange", type = "fl.events.DataChangeEvent")]
	
	/**
	 * 数据驱动
	 * @author tb
	 * 
	 */	
	public class ArrayProvider extends EventDispatcher
	{
		private var _data:Array = [];
		public var autoUpdate:Boolean = true;//启用/禁止广播事件
		
		public function ArrayProvider(data:Array = null)
		{
			if(data)
			{
				_data = data.concat();
			}
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
			dispatchChangeEvent(DataChangeType.RESET, _data.concat(), 0, _data.length-1);
		}
			
		/**
		 * 广播查询项，因为有可能需要从服务器查询，每个接口不一样，这里只提供广播数据 
		 * @param ed 侦听广播的对象 
		 * @param item
		 * 
		 */		
		public function dispatchSelect(ed:IEventDispatcher,item:*):void
		{
			var index:int = _data.push(item);
			ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.SELECT, [item], index, index));
		}
		
		/**
		 * 广播多个查询项，因为有可能需要从服务器查询，每个接口不一样，这里只提供广播数据
		 * @param ed 侦听广播的对象
		 * @param items
		 * 
		 */		
		public function dispatchSelectMulti(ed:IEventDispatcher,items:Array):void
		{
			var len:int = _data.length - 1;
			_data.splice(len,0,items);
			ed.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.SELECT, items, len, _data.length-1));
		}
		
		/**
		 * 添加 
		 * @param item
		 * 
		 */		
		public function add(item:*):void
		{
			var index:int = _data.push(item);
			dispatchChangeEvent(DataChangeType.ADD, [item], index, index);
		}
		
		/**
		 * 添加 
		 * @param item
		 * @param index
		 * 
		 */		
		public function addAt(item:*, index:uint):void
		{
			checkIndex(index);
			_data.splice(index, 0, item);
			dispatchChangeEvent(DataChangeType.ADD, [item], index, index);
		}
		
		/**
		 * 添加多个项
		 * @param items
		 * 
		 */		
		public function addMulti(items:Array):void
		{
			addMultiAt(items, _data.length-1);
		}
		
		/**
		 * 从指定的索引添加多个项
		 * @param items
		 * @param index
		 * 
		 */		
		public function addMultiAt(items:Array, index:uint):void
		{
			checkIndex(index);
			_data.splice(index,0,items);
			dispatchChangeEvent(DataChangeType.ADD, items.concat(), index, index + items.length - 1);
		}
		
		/**
		 * 获取 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getItemAt(index:uint):*
		{
			checkIndex(index);
			return _data[index];
		}
		
		/**
		 * 获取索引 
		 * @param item
		 * @return 
		 * 
		 */		
		public function getItemIndex(item:*):int
		{
			return _data.indexOf(item);
		}
		
		/**
		 * 是否有指定项 
		 * @param item
		 * @return 
		 * 
		 */		
		public function contains(item:*):Boolean
		{
			if(_data.indexOf(item) == -1)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 移除 
		 * @param item
		 * @return 
		 * 
		 */		
		public function remove(item:*):*
		{
			var index:int = _data.indexOf(item);
			if (index != -1)
			{
				return removeAt(index)[0];
			}
			return null;
		}
		
		/**
		 * 移除
		 * @param index 移除的索引位置
		 * @param count 移除个数，默认为1个
		 * @return 
		 * 
		 */		
		public function removeAt(index:uint,count:uint=1):Array
		{
			checkIndex(index);
			var arr:Array = _data.splice(index, count);
			dispatchChangeEvent(DataChangeType.REMOVE, arr.concat(), index, index+arr.length-1);
			return arr;
		}
		
		/**
		 * 移除全部
		 * 
		 */		
		public function removeAll():void
		{
			var arr:Array = _data.concat();
			_data = [];
			dispatchChangeEvent(DataChangeType.REMOVE_ALL, arr, 0, arr.length-1);
		}
		
		/**
		 * 移除多个项 
		 * @param items
		 * @return 
		 * 
		 */		
		public function removeMulti(items:Array):Array
		{
			var arr:Array = [];
			_data = _data.filter(function(item:*,index:int,array:Array):Boolean
			{
				if(items.indexOf(item) == -1)
				{
					return true;
				}
				else
				{
					arr.push(item);
					return false;
				}
			},this);
			if(arr.length > 0)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, arr.concat(), 0, arr.length-1);
			}
			return arr;
		}
		
		/**
		 * 移除多个索引项 
		 * @param indexs
		 * @return 
		 * 
		 */		
		public function removeMultiIndex(indexs:Array):Array
		{
			var arr:Array = [];
			_data = _data.filter(function(item:*,index:int,array:Array):Boolean
			{
				if(indexs.indexOf(index) == -1)
				{
					return true;
				}
				else
				{
					arr.push(item);
					return false;
				}
			},this);
			if(arr.length > 0)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, arr.concat(), 0, arr.length-1);
			}
			return arr;
		}
		
		/**
		 * 从指定属性的指定值中移除 
		 * @param p
		 * @param value
		 * 
		 */	
		public function removeForProperty(p:String,value:*):*
		{
			var _item:*;
			var _index:int;
			var b:Boolean = _data.some(function(item:*, index:int, array:Array):Boolean
			{
				if(item[p] == value)
				{
					_item = item;
					_index = index;
					return true;
				}
				return false;
			},this);
			if(b)
			{
				dispatchChangeEvent(DataChangeType.REMOVE, [_item], _index, _index);
			}
			return _item;
		}
		
		/**
		 * 从指定属性的指定值中移除,如果只移除一个用removeForProperty方法
		 * @param p
		 * @param value
		 * 
		 */	
		public function removeMultiForProperty(p:String,value:*):Array
		{
			var arr:Array = [];
			_data = _data.filter(function(item:*, index:int, array:Array):Boolean
			{
				if(item[p] == value)
				{
					arr.push(item);
					return false;
				}
				else
				{
					return true;
				}
			},this);
			if(arr.length == 0)
			{
				return arr;
			}
			dispatchChangeEvent(DataChangeType.REMOVE, arr, 0, arr.length-1);
			return arr;
		}
		
		/**
		 * 更新，oldItem必须是原数据的引用
		 * @param oldItem
		 * @param newItem
		 * @return 
		 * 
		 */		
		public function upDateItem(oldItem:*,newItem:*):*
		{
			var index:int = _data.indexOf(oldItem);
			if (index != -1)
			{
				return upDateItemAt(index,newItem);
			}
			return null;
		}
		
		/**
		 * 更新 
		 * @param newItem
		 * @param index
		 * @return 
		 * 
		 */		
		public function upDateItemAt(index:uint,newItem:*):*
		{
			checkIndex(index);
			var oldItem:* = _data[index];
			dispatchPreChangeEvent(DataChangeType.UPDATE, [oldItem], index, index);
			_data[index] = newItem;
			dispatchChangeEvent(DataChangeType.UPDATE, [newItem], index, index);
			return oldItem;
		}
		
		/**
		 * 设置项的索引位置， 此项必须是原数据的引用，如果不是用addItemAt方法
		 * @param item
		 * @param newIndex
		 * 
		 */		
		public function setItemIndex(item:*,newIndex:int):void
		{
			checkIndex(newIndex);
			var index:int = _data.indexOf(item);
			if (index == -1)
			{
				return ;
			}
			setItemIndexAt(index,newIndex);
		}
		
		/**
		 * 设置项的索引位置
		 * @param index
		 * @param newIndex
		 * 
		 */		
		public function setItemIndexAt(index:int,newIndex:int):void
		{
			checkIndex(index);
			checkIndex(newIndex);
			var arr:Array = _data.splice(index,1);
			_data.splice(newIndex,0,arr);
			dispatchChangeEvent(DataChangeType.MOVE, arr, index, newIndex);
		}
		
		/**
		 * 交换两个项的索引位置，此项必须是原数据的引用，如果不是用addItemAt方法
		 * @param item1
		 * @param item2
		 * 
		 */		
		public function swapItemAt(item1:*,item2:*):void
		{
			var index1:int = _data.indexOf(item1);
			if (index1 == -1)
			{
				return ;
			}
			var index2:int = _data.indexOf(item2);
			if (index2 == -1)
			{
				return ;
			}
			swapIndexAt(index1,index2);
		}
		
		/**
		 * 交换两个索引位置的项 
		 * @param index1
		 * @param index2
		 * 
		 */		
		public function swapIndexAt(index1:int, index2:int):void
		{
			if(index1 == index2)
			{
				return ;
			}
			checkIndex(index1);
			checkIndex(index2);
			//
			var arr1:Array;
			var arr2:Array;
			if(index1<index2)
			{
				arr2 = _data.splice(index2,1);
				arr1 = _data.splice(index1,1,arr2);
				_data.splice(index2,1,arr1);
				dispatchChangeEvent(DataChangeType.SWAP, arr2.concat(arr1), index1, index2);
			}
			else
			{
				arr1 = _data.splice(index1,1);
				arr2 = _data.splice(index2,1);
				_data.splice(index1,1,arr2);
				dispatchChangeEvent(DataChangeType.SWAP, arr1.concat(arr2), index2, index1);
			}
		}
		
		/**
		 * 对数组中的元素进行排序
		 * @param args
		 * @return 
		 * 
		 */		
		public function sort(... args):Array
		{
			dispatchPreChangeEvent(DataChangeType.SORT, _data.concat(), 0, _data.length - 1);
			var arr:Array = _data.sort(args);
			dispatchChangeEvent(DataChangeType.SORT, _data.concat(), 0, _data.length - 1);
			return arr;
		}
		
		/**
		 * 根据数组中的一个或多个字段对数组中的元素进行排序 
		 * @param fieldName
		 * @param options
		 * @return 
		 * 
		 */		
		public function sortOn(fieldName:Object, options:Object = null):Array
		{
			dispatchPreChangeEvent(DataChangeType.SORT, _data.concat(), 0, _data.length - 1);
			var arr:Array = _data.sortOn(fieldName, options);
			dispatchChangeEvent(DataChangeType.SORT, _data.concat(), 0, _data.length - 1);
			return arr;
		}
		/**
		 * 删除数组中最后一个元素，并返回该元素的值。 
		 * @return *
		 */		
		public function pop():*
		{
			var item:* = _data.pop();
			var len:int = _data.length;
			dispatchChangeEvent(DataChangeType.REMOVE,[item],len,len);
			return item;
		}
		/**
		 * 删除数组中第一个元素，并返回该元素。
		 * @return *
		 */		
		public function shift():*
		{
			var item:* = _data.shift();
			dispatchChangeEvent(DataChangeType.REMOVE,[item],0,0);
			return item;
		}
		
		public function toArray():Array
		{
			return _data.concat();
		}
		
		override public function toString():String
		{
			return "ArrayProvider [" + _data.join(" , ") + "]";
		}
		
		protected function checkIndex(index:int):void
		{
			if (index > _data.length-1 || index < 0)
			{
				throw new RangeError("ArrayProvider index (" + index.toString() + ") is not in acceptable range (0 - " + (_data.length-1).toString() + ")");
			}
		}
		
		//--------------------------------------------------
		// Array 只为实现Array的API，无修改
		//--------------------------------------------------
		
		/**
		 * @see Array
		 */		
		public function forEach(callback:Function, thisObject:* = null):void
		{
			_data.forEach(callback, thisObject);
		}
		/**
		 * @see Array
		 */		
		public function filter(callback:Function, thisObject:* = null):Array
		{
			return _data.filter(callback, thisObject);
		}
		/**
		 * @see Array
		 */		
		public function some(callback:Function, thisObject:* = null):Boolean
		{
			return _data.some(callback, thisObject);
		}
		/**
		 * @see Array
		 */		
		public function every(callback:Function, thisObject:* = null):Boolean
		{
			return _data.every(callback, thisObject);
		}
		/**
		 * @see Array
		 */		
		public function map(callback:Function, thisObject:* = null):Array
		{
			return _data.map(callback, thisObject);
		}
		
		//--------------------------------------------------
		// event
		//--------------------------------------------------
		
		protected function dispatchChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1):void
		{
			if(!autoUpdate)
			{
				return ;
			}
			if(hasEventListener(DataChangeEvent.DATA_CHANGE))
			{
				dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, evtType, items, startIndex, endIndex));
			}
		}
		
		protected function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int = -1, endIndex:int = -1):void
		{
			if(!autoUpdate)
			{
				return ;
			}
			if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
			{
				dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
			}
		}
	}

}