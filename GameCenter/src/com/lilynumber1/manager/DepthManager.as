package com.lilynumber1.manager
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;


	/**
	 * 层深管理器,
	 * 只需要调用DepthManager.swapDepth(child, depth); 即可。
	 */
	public class DepthManager
	{
		private static var managers:Dictionary;
		
		/**
		 * 获取当前容器的层深管理器 
		 * @param container
		 * @return 
		 * 
		 */		
		public static function getManager(container:DisplayObjectContainer):DepthManager
		{
			if (!managers)
			{
				managers = new Dictionary(true);
			}
			var m:DepthManager = managers[container];
			if (!m)
			{
				m = new DepthManager();
				managers[container] = m;
			}
			return m;
		}
		
		/**
		 * 设置显示对象的层深 
		 * @param child
		 * @param depth
		 * @return 
		 * 
		 */		
		public static function swapDepth(child:DisplayObject, depth:Number):int
		{
			return getManager(child.parent).swapChildDepth(child, depth);
		}
		
		/**
		 * 设置当前容器的所有子显示对象层深 
		 * @param doc
		 * 
		 */		
		public static function swapDepthAll(doc:DisplayObjectContainer):void
		{
			var dm:DepthManager = getManager(doc);
			var len:int = doc.numChildren;
			var child:DisplayObject;
			var arr:Array = [];
			var i:int;
			for (i=0; i < len; i++)
			{
				child = doc.getChildAt(i);
				arr.push(child);
			}
			arr.sortOn("y",Array.NUMERIC);
			arr.forEach(function(item:DisplayObject,index:int,array:Array):void
			{
				doc.setChildIndex(item,index);
				dm.setDepth(item,item.y);
			});
			arr = null;
		}
		
		/**
		 * 清除当前容器的层深管理器
		 * @param container
		 * 
		 */		
		public static function clear(container:DisplayObjectContainer):void
		{
			delete managers[container];
		}
		
		/**
		 * 清除所有层深管理器
		 * 
		 */		
		public static function clearAll():void
		{
			managers = null;
		}
		
		//--------------------------------------------------------------
		// class
		//--------------------------------------------------------------
		
		private var depths:Dictionary;

		public function DepthManager()
		{
			depths = new Dictionary(true);
		}

		public function getDepth(child:DisplayObject):Number
		{
			if (depths[child] == null)
			{
				return countDepth(child, child.parent.getChildIndex(child), 0);
			}
			else
			{
				return depths[child];
			}
		}

		private function countDepth(child:DisplayObject, index:int, n:Number = 0):Number
		{
			if (depths[child] == null)
			{
				if (index == 0)
				{
					return 0;
				}
				else
				{
					return countDepth(child.parent.getChildAt(index - 1), index - 1, n + 1);
				}
			}
			else
			{
				return depths[child] + n;
			}
		}

		public function setDepth(child:DisplayObject, d:Number):void
		{
			depths[child] = d;
		}

		public function swapChildDepth(child:DisplayObject, depth:Number):int
		{
			var container:DisplayObjectContainer = child.parent;
			if (container == null)
			{
				throw new Error("child is not in a container!!");
			}
			var index:int = container.getChildIndex(child);
			var oldDepth:Number = getDepth(child);
			if (depth == oldDepth)
			{
				setDepth(child, depth);
				return index;
			}
			var n:int = container.numChildren;
			if (n < 2)
			{
				setDepth(child, depth);
				return index;
			}
			if (depth < getDepth(container.getChildAt(0)))
			{
				container.setChildIndex(child, 0);
				setDepth(child, depth);
				return 0;
			}
			else if (depth >= getDepth(container.getChildAt(n - 1)))
			{
				container.setChildIndex(child, n - 1);
				setDepth(child, depth);
				return n - 1;
			}
			var left:int = 0;
			var right:int = n - 1;
			if (depth > oldDepth)
			{
				left = index;
				right = n - 1;
			}
			else
			{
				left = 0;
				right = index;
			}
			while (right > left + 1)
			{
				var mid:int = left + (right - left) / 2;
				var midDepth:Number = getDepth(container.getChildAt(mid));
				if (midDepth > depth)
				{
					right = mid;
				}
				else if (midDepth < depth)
				{
					left = mid;
				}
				else
				{
					//means midDepth == depth
					container.setChildIndex(child, mid);
					setDepth(child, depth);
					return mid;
				}
			}
			var leftDepth:Number = getDepth(container.getChildAt(left));
			var rightDepth:Number = getDepth(container.getChildAt(right));
			var destIndex:int = 0;
			if (depth >= rightDepth)
			{
				if (index <= right)
				{
					destIndex = Math.min(right, n - 1);
				}
				else
				{
					destIndex = Math.min(right + 1, n - 1);
				}
			}
			else if (depth < leftDepth)
			{
				if (index < left)
				{
					destIndex = Math.max(left - 1, 0);
				}
				else
				{
					destIndex = left;
				}
			}
			else
			{
				if (index <= left)
				{
					destIndex = left;
				}
				else
				{
					destIndex = Math.min(left + 1, n - 1);
				}
			}
			container.setChildIndex(child, destIndex);
			setDepth(child, depth);
			return destIndex;
		}

		/**
		 * 设置显示对象到最底层
		 * @param mc
		 *
		 */
		public static function bringToBottom(mc:DisplayObject):void
		{
			var parent:DisplayObjectContainer = mc.parent;
			if (parent == null)
			{
				return;
			}
			if (parent.getChildIndex(mc) != 0)
			{
				parent.setChildIndex(mc, 0)
			}
		}

		/**
		 * 设置显示对象到最顶层
		 * @param mc
		 *
		 */
		public static function bringToTop(mc:DisplayObject):void
		{
			var parent:DisplayObjectContainer = mc.parent;
			if (parent == null)
			{
				return;
			}
			parent.addChild(mc);
		}
	}
}

