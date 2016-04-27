package com.lilynumber1.module
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 
	 * @author tb
	 * 
	 */	
	public interface IModule extends IEventDispatcher
	{
		function setup():void;
		function init(data:Object=null):void;
		function show():void;
		function hide():void;
		function destroy():void;
	}
}