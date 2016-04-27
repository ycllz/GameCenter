package com.lilynumber1.net
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import com.lilynumber1.events.SocketErrorEvent;
	import com.lilynumber1.events.SocketEvent;
	import com.lilynumber1.tmf.HeadInfo;
	import com.lilynumber1.tmf.TMF;

	/**
	 * SOCKET服务连接,用TMF协议广播数据
	 * @author tb
	 *
	 */
	public class SocketImpl extends Socket
	{
		private static var _cmdLabelMap:Dictionary = new Dictionary();
		
		/**
		 * 添加显示命令解析名，开发测试用，方便知道命令ID说明
		 * @param cmdID
		 * @param name
		 *
		 */
		public static function addCmdLabel(cmdID:uint,name:String):void
		{
			_cmdLabelMap[cmdID] = name;
		}
		
		/**
		 * 获取显示命令解析名，开发测试用，方便知道命令ID说明
		 * @param cmdID
		 * @return
		 *
		 */
		public static function getCmdLabel(cmdID:uint):String
		{
			if(cmdID in _cmdLabelMap)
			{
				return _cmdLabelMap[cmdID];
			}
			return "---";
		}
		
		//--------------------------------------------------------------
		// 
		//--------------------------------------------------------------
		
		private static const cmdPrefix:String = "cmd_";
		private static const errorPrefix:String = "error_";
		/**
		 * 最大包长 
		 */		
		public static const PACKAGE_MAX:uint = 8388608;
		private static const VERSION:String = "1";//版本号
		private static const HEAD_LENGTH:uint = 17;//包头长度,v1为17字节
		/**
		 * 用户ID 
		 */		
		public var userID:uint = 0;
		/**
		 * 连接的IP地址 
		 */		
		public var ip:String;
		/**
		 * 连接的端口 
		 */		
		public var port:int;
		/**
		 * 错误统计回调方法 
		 */		
		public var errorCallback:Function;
		
		//发包
		private var _result:uint = 0;//该字段作为发包自增序列号使用
		//
		//解包
		private var _packageLen:uint;//协议包总长度，网络字节序，不超过8k，网络序
		private var _headInfo:HeadInfo;//包头信息解析类
		private var _dataLen:uint;//内容数据长度
		private var _isGetHead:Boolean = true;//是否在获取包头数据
		
		public function SocketImpl()
		{
			
		}
		
		//--------------------------------------------------------------
		// get set
		//--------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------
		// public function
		//--------------------------------------------------------------

		/**
		 * 发送内容
		 * @param cmdID 命令号
		 * @param args Array
		 *
		 */
		
		public function send(cmdID:uint, args:Array):uint
		{
			var data:ByteArray = new ByteArray();
			for each(var i:* in args)
			{
				if (i is String)
				{
					data.writeUTFBytes(i);
				}
				else if(i is ByteArray)
				{
					data.writeBytes(i);
				}
				else
				{
					data.writeUnsignedInt(i);
				}
			}
			
			//
			/*if (cmdID > 1000)
			{
				_result++;
			}*/
			var length:uint = data.length + HEAD_LENGTH;
			writeUnsignedInt(length);
			writeUTFBytes(VERSION);
			writeUnsignedInt(cmdID);
			writeUnsignedInt(userID);
			//trace("自增：",_result)
			if(cmdID > 1000)
			{
				//writeInt(_result);
				
				var crc8_val:uint;
				for (var j:uint = 0; j < data.length; j++) 
				{
					crc8_val ^= (data[j] & 0xff);
				}
				
				_result = _result - uint(_result/7) + 147 + length%21 + cmdID%13 + crc8_val;
				writeInt(_result);
			}
			else
			{
				writeInt(0);
			}
			writeBytes(data);
			flush();
			sendDataError(cmdID);
			trace(">>Socket["+ip+":"+port.toString()+"][cmdID:"+cmdID+"]",getCmdLabel(cmdID),"[data length:"+data.length+"]");
			return _result;
		}
		
		/**
		 * 连接服务器 
		 * @param host 服务器IP地址
		 * @param port 服务器端口
		 * 
		 */		
		override public function connect(host:String, port:int):void
		{
			super.connect(host, port);
			this.ip = host;
			this.port = port;
			_result = 0;
			trace("连接SOCKET：：：：",host,port)
			addEventListener(ProgressEvent.SOCKET_DATA, onData);
		}
		
		/**
		 * 关闭连接 
		 * 
		 */		
		override public function close():void
		{
			removeEventListener(ProgressEvent.SOCKET_DATA, onData);
			if(connected)
			{
				super.close();
			}
			ip = "";
			port = -1;
			_result = 0;
		}

		//--------------------------------------------------------------
		// private function
		//--------------------------------------------------------------
		
		/**
		 * 错误统计用到的
		 * @param cmdID
		 *
		 */
		private function sendDataError(cmdID:uint):void
		{
			if(errorCallback != null)
			{
				errorCallback(cmdID,1);
			}
		}
		
		private function readDataError(cmdID:uint):void
		{
			if(errorCallback != null)
			{
				errorCallback(cmdID,0);
			}
		}
		
		//--------------------------------------------------------------
		// cmd Listener
		//--------------------------------------------------------------
		
		public function addCmdListener(cmdID:uint,listener:Function):void
		{
			addEventListener(cmdPrefix+cmdID.toString(),listener);
		}
		
		public function removeCmdListener(cmdID:uint,listener:Function):void
		{
			removeEventListener(cmdPrefix+cmdID.toString(),listener);
		}
		
		public function dispatchCmd(cmdID:uint,headInfo:HeadInfo,data:Object):Boolean
		{
			return dispatchEvent(new SocketEvent(cmdPrefix+cmdID.toString(),headInfo,data));
		}
		
		public function hasCmdListener(cmdID:uint):Boolean
		{
			return hasEventListener(cmdPrefix+cmdID.toString());
		}
		
		//--------------------------------------------------------------
		// error Listener
		//--------------------------------------------------------------
		
		public function addErrorListener(cmdID:uint,listener:Function):void
		{
			addEventListener(errorPrefix+cmdID.toString(),listener);
		}
		
		public function removeErrorListener(cmdID:uint,listener:Function):void
		{
			removeEventListener(errorPrefix+cmdID.toString(),listener);
		}
		
		public function dispatchError(cmdID:uint,headInfo:HeadInfo):Boolean
		{
			return dispatchEvent(new SocketErrorEvent(errorPrefix+cmdID.toString(),headInfo));
		}
		
		public function hasErrorListener(cmdID:uint):Boolean
		{
			return hasEventListener(errorPrefix+cmdID.toString());
		}
		
		//--------------------------------------------------------------
		// Event
		//--------------------------------------------------------------

		/**
		 * 接收数据,采用TMF广播数据
		 * @param e
		 *
		 */
		
		private function onData(e:Event):void
		{
			trace("socket onData handler....................")
			while (bytesAvailable > 0)
			{
				if (_isGetHead)
				{
					if (bytesAvailable >= HEAD_LENGTH)
					{
						_packageLen = readUnsignedInt();
						if(_packageLen < HEAD_LENGTH || _packageLen > PACKAGE_MAX)
						{
							readDataError(0);
							dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,null));
							readBytes(new ByteArray());
							return ;
						}
						_headInfo = new HeadInfo(this);
						
						if(_headInfo.cmdID == 1001)
						{
							_result = _headInfo.result;
						}
						
						trace("<<Socket["+ip+":"+port.toString()+"][cmdID:"+ _headInfo.cmdID+"]",getCmdLabel(_headInfo.cmdID));
						//错误
						if (_headInfo.result > 1000)
						{
							readDataError(_headInfo.cmdID);
							dispatchError(_headInfo.cmdID,_headInfo);
							dispatchEvent(new SocketErrorEvent(SocketErrorEvent.ERROR,_headInfo));
							if(connected)
							{
								continue;
								
							}
							else
							{
								break;
							}
						}
						
						_dataLen = _packageLen - HEAD_LENGTH;

						//只有包头，无包体时
						if (_dataLen == 0)
						{
							readDataError(_headInfo.cmdID);
							dispatchCmd(_headInfo.cmdID,_headInfo,null);
							if(connected)
							{
								continue;
								
							}
							else
							{
								break;
							}
						}
						else
						{
							_isGetHead = false;
						}
					}
					else
					{
						break;
					}
				}
				else
				{
					if (bytesAvailable >= _dataLen)
					{
						var data:ByteArray = new ByteArray();
						readBytes(data, 0, _dataLen);
						var tmfClass:Class = TMF.getClass(_headInfo.cmdID);
						_isGetHead = true;
						readDataError(_headInfo.cmdID);
						dispatchCmd(_headInfo.cmdID,_headInfo, new tmfClass(data));
						if(connected)
						{
							continue;
							
						}
						else
						{
							break;
						}
					}
					else
					{
						break;
					}
				}
			}
		}
	}
}