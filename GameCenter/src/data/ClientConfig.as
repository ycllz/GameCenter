package data
{
	import com.lilynumber1.ds.HashMap;
	
	import panel.Alert;
	import panel.JewelleryGameOverPanel;
	import panel.JewelleryGamePanel;
	import panel.JewelleryGameStartPanel;

	public class ClientConfig
	{
		private static var _isRelease:Boolean = false;//是否为发布版本
		private static var _version:String;//客户端版本
		private static var _serverVersion:int;//服务器版本
		private static var _urlParams:Object;
		
		public static var moduleMap:HashMap;
		public static function setup(isRelease:Boolean = false,version:String="",serverVersion:uint=0,parms:Object = null):void
		{
			_urlParams = parms;
			_isRelease = isRelease;
			_version = version;
			_serverVersion = serverVersion;
			moduleMap = new HashMap();
			moduleMap.add("Alert",new Alert());
			moduleMap.add("JewelleryGameOverPanel",new JewelleryGameOverPanel());
			moduleMap.add("JewelleryGamePanel",new JewelleryGamePanel());
			moduleMap.add("JewelleryGameStartPanel",new JewelleryGameStartPanel());
		}
		
		public static function isRelease():Boolean
		{
			return _isRelease;
		}
		
		public static function version():String
		{
			return _version;
		}
		
		public static function serverVersion():int
		{
			return _serverVersion;
		}
		
		public static function get urlParams():Object
		{
			if(_urlParams == null)
			{
				_urlParams = new Object();
			}
			return _urlParams;
		}
	}
}