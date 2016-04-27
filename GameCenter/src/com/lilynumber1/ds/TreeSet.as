package com.lilynumber1.ds
{

	/**
	 * 树集
	 * @author tb
	 *
	 */
	public class TreeSet implements ITree
	{
		private var _root:TreeSet;
		private var _parent:TreeSet;
		private var _children:HashSet;

		private var _data:*;

		public function TreeSet(data:* = null, parent:TreeSet = null)
		{
			_data = data;
			_children = new HashSet();

			this.parent = parent;
		}
		
		public function get data():*
		{
			return _data;
		}
		public function set data(d:*):void
		{
			_data = d;
		}
		
		/**
		 * 树的总长度
		 * @return
		 *
		 */
		public function get length():int
		{
			var c:int = numChildren;
			var node:TreeSet = _parent;
			while (node)
			{
				c += node.numChildren;
				node = node.parent;
				if (node == this)
				{
					throw new Error("TreeSet Infinite Loop");
				}
			}
			return c;
		}

		/**
		 * 是否为根
		 * @return
		 *
		 */
		public function get isRoot():Boolean
		{
			return _root == this;
		}

		/**
		 * 是否为叶(无子级)
		 * @return
		 *
		 */
		public function get isLeaf():Boolean
		{
			return _children.length == 0;
		}

		/**
		 * 深度
		 * @return
		 *
		 */
		public function get depth():int
		{
			if (!_parent)
			{
				return 0;
			}
			var node:TreeSet = _parent;
			var c:int = 0;
			while (node)
			{
				c++;
				node = node.parent;
				if (node == this)
				{
					throw new Error("TreeSet Infinite Loop");
				}
			}
			return c;
		}

		/**
		 * 子级个数
		 * @return
		 *
		 */
		public function get numChildren():int
		{
			return _children.length;
		}

		/**
		 * 同级个数
		 * @return
		 *
		 */
		public function get numSiblings():int
		{
			if (_parent)
			{
				return _parent.numChildren;
			}
			return 0;
		}

		/**
		 * 根
		 * @return
		 *
		 */
		public function get root():TreeSet
		{
			return _root;
		}

		/**
		 * 父级
		 * @param parent
		 *
		 */
		public function set parent(parent:TreeSet):void
		{
			if (_parent)
			{
				_parent.children.remove(this);
			}
			if (parent == this)
			{
				return;
			}
			_parent = parent;
			if (_parent)
			{
				_parent.children.add(this);
			}
			setRoot();
		}

		public function get parent():TreeSet
		{
			return _parent;
		}

		/**
		 * 子级列表
		 * @return
		 *
		 */
		public function get children():HashSet
		{
			return _children;
		}

		//--------------------------------------------------------
		// public function
		//--------------------------------------------------------
		
		/**
		 * 移除树，将此树丛整个树列表中移除，并把它的父级设为它的子级的父级，如果此树是根，则不进行操作
		 * (这与把parent设为空不同，parent设为空，包括他的子级也一起从树列表中移除)
		 * 
		 */		
		public function remove():void
		{
			if(_parent == null)
			{
				return ;
			}
			_children.each2(function(child:TreeSet):void
			{
				child.parent = _parent;
			});
		}
		
		public function clear():void
		{
			_children = new HashSet();
		}

		//--------------------------------------------------------
		// private function
		//--------------------------------------------------------

		/**
		 * 设置根
		 *
		 */
		private function setRoot():void
		{
			if (_parent == null)
			{
				_root = this;
				return;
			}

			var node:TreeSet = _parent;
			while (node)
			{
				if (node.parent == null)
				{
					_root = node;
					return;
				}
				node = node.parent;
				if (node == this)
				{
					throw new Error("TreeSet Infinite Loop");
				}
			}
		}
	}
}