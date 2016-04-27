package com.lilynumber1.algo
{
	/**
	 * 地图模型接口 
	 * @author tb
	 * 
	 */	
	public interface IMapModel
	{
		/**
		 * 网格大小 
		 * @return 
		 * 
		 */		
		function get gridSize():uint;
		
		/**
		 * 地图横向网格数
		 * @return 
		 * 
		 */		
		function get gridX():uint;
		/**
		 * 地图纵向网格数
		 * @return 
		 * 
		 */		
		function get gridY():uint;
		
		/**
		 * 整个地图的网格数据 
		 * @return 
		 * 
		 */		
		function get data():Array;
	}
	
}