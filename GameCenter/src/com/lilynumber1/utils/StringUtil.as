package com.lilynumber1.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * 字符串功能
	 * @author tb
	 * 
	 */	
	public class StringUtil
	{
		private static const HEX_Head:String = "0x";//十六进制数字表示头
		
		/**
		 * 在不够指定长度的字符串前补零
		 * @param str 需要在前面补零的字符串
		 * @param len 总长度
		 * @return
		 *
		 */
		public static function renewZero(str:String, len:int):String
		{
			var bul:String = "";
			var strLen:int = str.length;
			if (strLen < len)
			{
				for (var i:int = 0; i < len - strLen; i++)
				{
					bul += "0";
				}
				return bul + str;
			}
			else
			{
				return str;
			}
		}

		/**
		 * 格式数字秒表类型输出 00:00
		 * @param value
		 * @param length
		 * @return
		 *
		 */
		public static function stopwatchFormat(value:int):String
		{
			var minute:int = value / 60;
			var second:int = value % 60;
			var strM:String = (minute < 10) ? ("0" + minute.toString()) : minute.toString();
			var strS:String = (second < 10) ? ("0" + second.toString()) : second.toString();
			return strM + ":" + strS;
		}

		/**
		 * 日期格式
		 * @param value 时间
		 * @param sm    格式间隔符
		 * @return
		 *
		 */
		public static function timeFormat(value:int, sm:String = "-"):String
		{
			var t:Date = new Date(value * 1000);
			return t.getFullYear().toString() + sm + (t.getMonth() + 1).toString() + sm + t.getDate().toString();
		}
		
		/**
		 * 十进制数字转为IP地址格式 127.0.0.1
		 * @param a
		 * @return 
		 * 
		 */		
		public static function uintToIp(v:uint):String
		{
			var str:String = v.toString(16);
			var ip1:String = uint(HEX_Head+str.slice(0,2)).toString();
			var ip2:String = uint(HEX_Head+str.slice(2,4)).toString();
			var ip3:String = uint(HEX_Head+str.slice(4,6)).toString();
			var ip4:String = uint(HEX_Head+str.slice(6)).toString();
			return ip1+"."+ip2+"."+ip3+"."+ip4;
		}
		
		/**
		 * 十六进制数字转为IP地址格式
		 * @param a
		 * @return 
		 * 
		 */		
		public static function hexToIp(a:uint):String
		{
			//return (a>>24).toString()+"."+((a>>16)%256).toString()+"."+((a>>8)%256).toString()+"."+(a%256).toString();
			var by:ByteArray = new ByteArray();
			by.writeUnsignedInt(a);
			by.position = 0;
			var str:String = "";
			for(var i:uint = 0;i<4;i++)
			{
				str +=  by.readUnsignedByte().toString()+".";
			}
			return str.substr(0,str.length-1);
		}
		
		/**
		 * IP地址格式转为十进制数字 
		 * @return i
		 * 
		 */		
		public static function ipToUint(i:String):uint
		{
			var arr:Array = i.split(".");
			var str:String = HEX_Head;
			arr.reverse();
			for each(var item:String in arr)
			{
				str += uint(item).toString(16);
			}
			return uint(str);
		}
		
		public static function ipToBytes(i:String):ByteArray
		{
			var arr:Array = i.split(".");
			var bytes:ByteArray = new ByteArray();
			for each(var item:String in arr)
			{
				bytes.writeByte(uint(item));
			}
			return bytes;
		}
		
		/**
		 * 对比两个字符串 
		 * @param s1
		 * @param s2
		 * @param caseSensitive 是否区分大小写
		 * @return 
		 * 
		 */		
		public static function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean):Boolean
		{
			if (caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}
		
		/**
		 * 去掉两边空格 
		 * @param input
		 * @return 
		 * 
		 */		
		public static function trim(input:String):String
		{
			return StringUtil.leftTrim(StringUtil.rightTrim(input));
		}
		
		/**
		 * 去掉左边空格 
		 * @param input
		 * @return 
		 * 
		 */		
		public static function leftTrim(input:String):String
		{
			var size:Number = input.length;
			for (var i:Number = 0; i < size; i++)
			{
				if (input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}
		
		/**
		 * 去掉右边空格 
		 * @param input
		 * @return 
		 * 
		 */		
		public static function rightTrim(input:String):String
		{
			var size:Number = input.length;
			for (var i:Number = size; i > 0; i--)
			{
				if (input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}
		
		/**
		 * 一个字符串从开头起是否有指定的字符串 
		 * @param input
		 * @param prefix
		 * @return 
		 * 
		 */		
		public static function beginsWith(input:String, prefix:String):Boolean
		{
			return (prefix == input.substring(0, prefix.length));
		}
		
		/**
		 * 一个字符串从结尾起是否有指定的字符串 
		 * @param input
		 * @param suffix
		 * @return 
		 * 
		 */		
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}
		
		/**
		 * 移除字符串中指定的字符串 
		 * @param input
		 * @param remove
		 * @return 
		 * 
		 */		
		public static function remove(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}
		
		
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:Number = input.length;
			var rLen:Number = replace.length;

			for (var i:Number = 0; i < sLen; i++)
			{
				if (input.charAt(i) == replace.charAt(0))
				{
					found = true;
					for (var j:Number = 0; j < rLen; j++)
					{
						if (!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if (found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			return sb;
		}

		public static function stringHasValue(s:String):Boolean
		{
			return (s != null && s.length > 0);
		}
		
		/**
		 * 将字符串转化为字节数组 
		 * @param s
		 * @param length
		 * @return 
		 * 
		 */		
		public static function toByteArray(s:String,length:uint):ByteArray
		{
			var _byte:ByteArray = new ByteArray();
			_byte.writeUTFBytes(s);
			_byte.length = length;
			_byte.position = 0;
			return _byte;
		}
	}
}