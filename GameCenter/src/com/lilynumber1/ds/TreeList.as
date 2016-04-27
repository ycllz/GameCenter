package com.lilynumber1.ds
{

	/**
	 * 树列
	 * @author tb
	 *
	 */
	public class TreeList implements ITree
	{
		private var _root:TreeList;
		private var _parent:TreeList;
		private var _children:Array;

		private var _data:*;

		public function TreeList(data:* = null, parent:TreeList = null)
		{
			_data = data;
			_children = [];
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
			var node:TreeList = _parent;
			while (node)
			{
				c += node.numChildren;
				node = node.parent;
				if(node == this)
				{
					throw new Error("TreeList Infinite Loop");
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
			if (_parent == null)
			{
				return 0;
			}
			var node:TreeList = _parent;
			var c:int = 0;
			while (node)
			{
				c++;
				node = node.parent;
				if(node == this)
				{
					throw new Error("TreeList Infinite Loop");
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
		public function get root():TreeList
		{
			return _root;
		}

		/**
		 * 父级
		 * @param parent
		 *
		 */
		public function set parent(parent:TreeList):void
		{
			if (_parent)
			{
				var index:int = _parent.children.indexOf(this);
				if (index != -1)
				{
					_parent.children.splice(index, 1);
				}
			}
			if (parent == this)
			{
				return;
			}
			_parent = parent;
			if (_parent)
			{
				_parent.children.push(this);
			}
			setRoot();
		}

		public function get parent():TreeList
		{
			return _parent;
		}

		/**
		 * 子级列表
		 * @return
		 *
		 */
		public function get children():Array
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
			for each(var child:TreeList in _children)
			{
				child.parent = _parent;
			}
		}
		
		/**
		 * 清空子级
		 *
		 */
		public function clear():void
		{
			_children = [];
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

			var node:TreeList = _parent;
			while (node)
			{
				if (node.parent == null)
				{
					_root = node;
					return;
				}
				node = node.parent;
				if(node == this)
				{
					throw new Error("TreeList Infinite Loop");
				}
			}
		}
	}
}