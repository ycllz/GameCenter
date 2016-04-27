package com.lilynumber1.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.getQualifiedClassName;
	
	import com.lilynumber1.ds.HashMap;
	import com.lilynumber1.resource.ResInfo;
	import com.lilynumber1.resource.ResLoader;
	import com.lilynumber1.utils.ArrayUtil;

	/**
	 * 统一资源管理,资源缓存，资源加载
	 * @author tb
	 *
	 */
	public class ResourceManager
	{
		/**
		 * 资源加载错误
		 */		
		public static const RESOUCE_ERROR:String = "resourceError";
		/**
		 * 资源加载后导出
		 */		
		public static const RESOUCE_REFLECT_ERROR:String = "resourceReflectError";
		
		/**
		 *最高优先权，不等待任何加载项，立即启动加载，如果有正在加载的将被关闭
		 */
		public static const HIGHEST:int = 0;
		/**
		 * 高与标准，排在标准前面
		 */
		public static const HIGH:int = 1;
		/**
		 *标准
		 */
		public static const STANDARD:int = 2;
		/**
		 *优先级比较低，等待所有标准以上的不在缓存中就补上去
		 */
		public static const LOW:int = 3;
		/**
		 * 优先级最低，正在加载象为空的时候进行加载。出现非空闲状态，该项将被中断加载
		 */
		public static const LOWEST:int = 4;

		//

		/**
		 * 并行加载最大数目
		 */
		public static var maxLpt:uint = 2;
		/**
		 * 最大缓存数
		 */
		public static var maxCache:uint = 300;

		/**
		 * 需要加载的资源列表，内容类型：ResInfo
		 */
		private static var _dataList:Array = [];
		/**
		 * 加载器列表 ，内容类型：ResLoader
		 */
		private static var _loaderList:Array = [];
		/**
		 * 缓存列表 ，内容类型：{url:String,res:Class或BitmapData}
		 */
		private static var _cacheList:Array = [];
		
		private static var _cacheMultiList:Array = [];
		
		private static var _isStop:Boolean = false;

		//--------------------------------------------------
		// public static function
		//--------------------------------------------------
		
		/**
		 * 从指定的URL中获取资源
		 * @param url    路径
		 * @param event  event(content:DisplayObject)
		 * @param name   默认""获取整个swf类
		 * @param level  加载优先级别
		 * @param isCache  是否缓存
		 */
		public static function getResource(url:String, event:Function, name:String = "item", level:int = 3, isCache:Boolean = true):void
		{
			//获取缓存中的资源类
			if (_cacheList.length > 0)
			{
				for each (var n:Object in _cacheList)
				{
					if (n.url == url)
					{
						if (n.res is BitmapData)
						{
							event(new Bitmap(n.res as BitmapData));
						}
						else
						{
							event(new n.res());
						}
						return;
					}
				}
			}

			//添加加载信息
			var isHas:Boolean = _dataList.some(function(item:ResInfo,index:int,array:Array):Boolean
			{
				if (item.url == url)
				{
					item.eventList.push(event);
					return true;
				}
				return false;
			});

			if (!isHas)
			{
				var resInfo:ResInfo = new ResInfo();
				resInfo.eventList.push(event);
				resInfo.isCache = isCache;
				resInfo.level = level;
				resInfo.url = url;
				resInfo.name = name;
				_dataList.push(resInfo);
				_dataList.sortOn("level", Array.NUMERIC);

				//获取空闲的加载器
				var resLoader:ResLoader = getEmptyLoader(level);
				if (resLoader)
				{
					resLoader.load(resInfo);
				}
			}
		}
		
		/**
		 * 从指定的URL中获取多个资源
		 * @param url      路径
		 * @param event    event(arr:Array)
		 * @param nameList 一个swf文件里的资源名列表
		 * @param level    加载优先级别
		 * @param isCache  是否缓存
		 * 
		 */		
		public static function getResourceList(url:String, event:Function, nameList:Array, level:int = 3, isCache:Boolean = true):void
		{
			//获取缓存中的资源类
			if (_cacheMultiList.length > 0)
			{
				var outArr:Array = [];
				for each (var n:Object in _cacheMultiList)
				{
					if (n.url == url)
					{
						var cmap:HashMap = n.map;
						for(var name:String in nameList)
						{
							var res:Class = cmap.getValue(name);
							if(res)
							{
								if (res is BitmapData)
								{
									outArr.push(new Bitmap(res as BitmapData));
								}
								else
								{
									outArr.push(new res());
								}
							}
						}
						break;
					}
				}
				if(outArr.length == nameList.length)
				{
					event(outArr);
					return ;
				}
			}

			//添加加载信息
			var isHas:Boolean = false;
			var dLen:int = _dataList.length;
			if (dLen > 0)
			{
				for each (var rn:ResInfo in _dataList)
				{
					if (rn.url == url)
					{
						if(rn.name == "")
						{
							rn.eventList.push(event);
							isHas = true;
						}
						break;
					}
				}
			}

			if (!isHas)
			{
				var resInfo:ResInfo = new ResInfo();
				resInfo.eventList.push(event);
				resInfo.isCache = isCache;
				resInfo.level = level;
				resInfo.url = url;
				nameList.sort();
				resInfo.nameList = nameList;
				_dataList.push(resInfo);
				_dataList.sortOn("level", Array.NUMERIC);

				//获取空闲的加载器
				var resLoader:ResLoader = getEmptyLoader(level);
				if (resLoader)
				{
					resLoader.load(resInfo);
				}
			}
		}
		
		

		/**
		 * 取消指定加载项
		 * @param url
		 * @param event
		 *
		 */
		public static function cancel(url:String, event:Function):void
		{
			cancelEmpl(url, event);
		}

		/**
		 * 取消相同URL的全部加载项
		 * @param url
		 *
		 */
		public static function cancelURL(url:String):void
		{
			cancelEmpl(url);
		}

		/**
		 * 取消全部加载项
		 *
		 */
		public static function cancelAll():void
		{
			for each (var o:ResLoader in _loaderList)
			{
				removeLoader(o);
			}
			_loaderList = [];
			_dataList = [];
		}
		
		
		/**
		 * 添加预加载 
		 * @param url
		 * @param name
		 * @param isCache
		 * 
		 */		
		public static function addBef(url:String, name:String = "item", isCache:Boolean = true):void
		{
			//添加加载信息
			var isHas:Boolean = false;
			var dLen:int = _dataList.length;
			if (dLen > 0)
			{
				for each (var rn:ResInfo in _dataList)
				{
					if (rn.url == url)
					{
						isHas = true;
						break;
					}
				}
			}

			if (!isHas)
			{
				var resInfo:ResInfo = new ResInfo();
				resInfo.isCache = isCache;
				resInfo.level = LOWEST;
				resInfo.url = url;
				resInfo.name = name;
				_dataList.push(resInfo);
			}
		}
		
		/**
		 * 停止加载 
		 * 
		 */		
		public static function stop():void
		{
			_isStop = true;
			for each (var resLoader:ResLoader in _loaderList)
			{
				if(resLoader.level == LOWEST)
				{
					removeLoader(resLoader);
				}
			}
		}
		
		/**
		 * 开启加载 
		 * 
		 */		
		public static function play():void
		{
			_isStop = false;
			nextLoad();
		}
		
		//--------------------------------------------------
		// private static function
		//--------------------------------------------------

		/**
		 * 取消指定的加载项,event参数为空值时，取消相同URL的全部加载项
		 * @param url
		 * @param event
		 *
		 */
		private static function cancelEmpl(url:String, event:Function = null):void
		{
			//
			for each (var resLoader:ResLoader in _loaderList)
			{
				if (resLoader.resInfo.url == url)
				{
					if (event != null)
					{
						var eindex:int = resLoader.resInfo.eventList.indexOf(event);
						if (eindex == -1)
						{
							return;
						}
						resLoader.resInfo.eventList.splice(eindex, 1);
						if (resLoader.resInfo.eventList.length > 0)
						{
							return;
						}
					}
					removeLoader(resLoader);
					
					//从_dataList中移除
					var len:int = _dataList.length;
					for (var i:int = 0; i < len; i++)
					{
						if (_dataList[i].url == url)
						{
							_dataList.splice(i, 1);
							break;
						}
					}
					//
					nextLoad();
					return;
				}
			}
		}

		/**
		 * 获取空闲的加载器,获取优先级别最低的加载器并停止加载。
		 * @return
		 *
		 */
		private static function getEmptyLoader(level:int=3):ResLoader
		{
			var resLoader:ResLoader;
			var len:int = _loaderList.length;
			if (len < maxLpt)
			{
				resLoader = new ResLoader();
				resLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				resLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loaderList.push(resLoader);
				return resLoader;
			}
			//
			_loaderList.sortOn("level", Array.NUMERIC | Array.DESCENDING);
			resLoader = _loaderList[0] as ResLoader;
			if (level == HIGHEST)
			{
				resLoader.close();
				return resLoader;
			}
			else if (level != LOWEST)
			{
				if (resLoader.level == LOWEST)
				{
					resLoader.close();
					return resLoader;
				}
			}
			return null;
		}

		/**
		 * 下一个加载 
		 * 
		 */		
		private static function nextLoad():void
		{
			if(_isStop)
			{
				return ;
			}
			//是否还有可加载信息
			var len:int = _dataList.length;
			if (len > 0)
			{
				for (var k:int = 0; k < len; k++)
				{
					var resInfo:ResInfo = _dataList[k] as ResInfo;
					if (!resInfo.isLoading)
					{
						//获取空闲的加载器
						var resLoader:ResLoader = getEmptyLoader();
						if (resLoader)
						{
							resLoader.load(resInfo);
						}
						break;
					}
				}
			}
		}

		private static function removeLoader(resLosder:ResLoader):void
		{
			ArrayUtil.removeValueFromArray(_loaderList, resLosder);
			if (resLosder.isLoading)
			{
				resLosder.close();
			}
			resLosder.removeEventListener(Event.COMPLETE, onLoadComplete);
			resLosder.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			resLosder.destroy();
			resLosder = null;
		}

		//--------------------------------------------------
		// event
		//--------------------------------------------------

		private static function onLoadComplete(e:Event):void
		{
			var resLoader:ResLoader = e.target as ResLoader;
			var loaderInfo:LoaderInfo = resLoader.loaderInfo;
			var resInfo:ResInfo = resLoader.resInfo;
			
			//
			var eventList:Array = resInfo.eventList;
			//添加缓存并回调方法传递参数
			if (loaderInfo.content is Bitmap)
			{
				var bd:BitmapData = (loaderInfo.content as Bitmap).bitmapData.clone();
				if (resInfo.isCache)
				{
					_cacheList.push({url: resInfo.url, res: bd});
				}
				for each (var d:Function in eventList)
				{
					d(new Bitmap(bd));
				}
			}
			else
			{
				var cla:Class;
				if (resInfo.name == "")
				{
					var nlen:int = resInfo.nameList.length;
					if(nlen == 0)
					{
						//无反射名，反射整个swf
						cla = loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(loaderInfo.content)) as Class;
						if (resInfo.isCache)
						{
							_cacheList.push({url: resInfo.url, res: cla});
						}
						for each (var dd:Function in eventList)
						{
							dd(new cla());
						}
					}
					else
					{
						//多个反射名
						var outArr:Array = [];
						var cacheMap:HashMap = new HashMap();
						var nameList:Array = resInfo.nameList;
						for each(var resName:String in nameList)
						{
							if(loaderInfo.applicationDomain.hasDefinition(resName))
							{
								cla = loaderInfo.applicationDomain.getDefinition(resName) as Class;
								if (cla)
								{
									cacheMap.add(resName,cla);
									if (cla is BitmapData)
									{
										outArr.push(new Bitmap(cla as BitmapData));
									}
									else
									{
										outArr.push(new cla());
									}
								}
							}
							else
							{
								EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
							}
						}
						if (resInfo.isCache)
						{
							var hasURL:Boolean = _cacheMultiList.some(function(item:Object,index:int,array:Array):Boolean
							{
								if(item.url == resInfo.url)
								{
									var cmap:HashMap = item.map;
									cacheMap.each2(function(key:*,value:*):void
									{
										cmap.add(key,value);
									});
									return true;
								}
								return false;
							});
							if(!hasURL)
							{
								_cacheMultiList.push({url: resInfo.url, map: cacheMap});
							}
						}
						else
						{
							cacheMap = null;
						}
						
						if(outArr.length>0)
						{
							for each (var nl:Function in eventList)
							{
								nl(outArr);
							}
						}
						//
						if (_cacheMultiList.length > maxCache)
						{
							_cacheMultiList.shift();
						}
					}
				}
				else
				{
					//单个反射名
					if(loaderInfo.applicationDomain.hasDefinition(resInfo.name))
					{
						cla = loaderInfo.applicationDomain.getDefinition(resInfo.name) as Class;
					}
					else
					{
						EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
					}
					if (cla)
					{
						if (resInfo.isCache)
						{
							_cacheList.push({url: resInfo.url, res: cla});
						}
						for each (var n:Function in eventList)
						{
							n(new cla());
						}
					}
				}
			}
			
			//
			//
			removeLoader(resLoader);
			//
			if (_cacheList.length > maxCache)
			{
				_cacheList.shift();
			}

			//移除加载完成的信息
			ArrayUtil.removeValueFromArray(_dataList, resInfo);
			//
			nextLoad();
		}

		private static function onIOError(e:IOErrorEvent):void
		{
			var resLoader:ResLoader = e.target as ResLoader;
			var resInfo:ResInfo = resLoader.resInfo;
			removeLoader(resLoader);
			ArrayUtil.removeValueFromArray(_dataList, resInfo);
			nextLoad();
			EventManager.dispatchEvent(new Event(RESOUCE_ERROR));
			//throw new IOError("资源加载路径不正确:" + resInfo.url);
			trace("资源加载路径不正确:" + resInfo.url);
		}
	}
}