package com.lilynumber1.utils
{
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;

	/**
	 * SO写入缓存池,避免同时间写入SO造成的客户端响应慢
	 * @author tb
	 *
	 */
	public class SOFlushPool
	{
		//间隔时间
		private static const TIME:int = 100;
		//Pool队列
		private var _poolList:Array;
		private var _time:Timer;

		public function SOFlushPool()
		{
			_poolList = new Array();
			_time = new Timer(TIME, 0);
			_time.addEventListener(TimerEvent.TIMER, onTime);
		}
		
		/**
		 * 添加要写入的SharedObject
		 * @param so
		 * 
		 */		
		public function addFlush(so:SharedObject):void
		{
			if (!isInPool(so))
			{
				_poolList.push(so);
				if (!_time.running)
				{
					_time.reset();
					_time.start();
				}
			}
		}

		private function isInPool(so:SharedObject):Boolean
		{
			return _poolList.indexOf(so) != -1;
		}

		private function onTime(e:TimerEvent):void
		{
			var shareObject:SharedObject = _poolList.shift();
			if (shareObject != null)
			{
				try
				{
					shareObject.flush();
				}
				catch (e:Error)
				{
					trace("SOFlushPool.flush",e.toString());
				}
			}
			else
			{
				_time.stop();
			}
		}
	}
}