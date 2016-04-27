package com.lilynumber1.ds
{
	/**
	 * 
	 * @author tb
	 * 
	 */	
	public interface ITree
	{
		function get data():*;
		function set data(d:*):void;
		
		function get length():int;
		function get isRoot():Boolean;
		function get isLeaf():Boolean;
		function get depth():int;
		function get numChildren():int;
		function get numSiblings():int;
		
		function remove():void;
		function clear():void;
	}
}