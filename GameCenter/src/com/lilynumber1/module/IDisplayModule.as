package com.lilynumber1.module
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * 显示功能模块 
	 * @author tb
	 * 
	 */	
	public interface IDisplayModule extends IModule
	{
		function get sprite():Sprite;
		function get parentContainer():DisplayObjectContainer;
	}
}