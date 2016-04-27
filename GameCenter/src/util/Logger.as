package util
{
	import data.ClientConfig;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 日志
	 **/
	public class Logger
	{
		public static var NONE:int = 1000;
		public static var FATAL:int = 16;
		public static var ERROR:int = 8;
		public static var DEBUG:int = 4;
		public static var INFO:int = 2;
		public static var ALL:int = 0;
		
		/**
		 * 当前日志级别. 默认为NONE.
		 **/
		public static var level:int = ERROR;
		
		public static function info(context:Object, message:String):void 
		{
			log(INFO, context, message);
		}
		
		public static function debug(context:Object, message:String):void 
		{
			log(DEBUG, context, message);
		}
		
		public static function error(context:Object, message:String):void 
		{
			log(ERROR, context, message);
		}
		
		public static function fatal(context:Object, message:String):void 
		{
			log(FATAL, context, message);
		}
		
		public static function createLogMsgByArr( ... args):String
		{
			var str:String = "";
			for (var i:uint=0; i<args.length; i++) 
			{
				str += args[i] + "  ";
			}
			return str;
		}
		
		private static function log(msgLevel:int, context:Object, message:String):void 
		{
			if(ClientConfig.isRelease())
			{
				return;
			}
			var className:String = "";
			if(context == null)
			{
				className = "unknow class type or static class";
			}else
			{
				className = getQualifiedClassName(context)
			}
			if(level <= msgLevel) 
			{
				trace(pad("[" + levelString(msgLevel) + "] " + className ) + " : " + message);
			}
		}
		
		private static function pad(str:String):String 
		{
			while ( str.length < 50 ) 
			{
				str += " ";
			}
			return str;
		}
		
		private static function levelString(whichLevel:int):String 
		{
			switch (whichLevel) 
			{
				case NONE: return "";
				case FATAL: return "FATAL";
				case ERROR: return "ERROR";
				case DEBUG: return "DEBUG";
				case INFO: return "INFO";
				case ALL: return "ALL";
			}
			return "";
		}

	}
}