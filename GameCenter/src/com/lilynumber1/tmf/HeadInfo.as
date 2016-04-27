package com.lilynumber1.tmf
{
	import flash.utils.IDataInput;
	
	/**
	 * socket传输包头信息 
	 * @author tb
	 * 
	 */	
	public class HeadInfo
	{
		private var _version:String;//版本号
		private var _cmdID:uint;//消息命令字，网络序
		private var _userID:uint;//用户ID号，网络序
		private var _result:int;//处理结果。在Client-〉Server类型中，该字段作为自增序列号使用。Server-〉Client的应答消息中，v1版本中该字段表示处理的错误码。
		
		public function HeadInfo(headData:IDataInput)
		{
			_version = headData.readUTFBytes(1);
			_cmdID = headData.readUnsignedInt();
			_userID = headData.readUnsignedInt();
			_result = headData.readInt();
		}
		public function get version():String
		{
			return _version;
		}
		public function get cmdID():uint
		{
			return _cmdID;
		}
		public function get userID():uint
		{
			return _userID;
		}
		public function get result():int
		{
			return _result;
		}
	}
}