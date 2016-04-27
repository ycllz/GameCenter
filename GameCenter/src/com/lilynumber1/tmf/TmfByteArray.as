package com.lilynumber1.tmf
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	/**
	 * tmf协议用到的
	 * @author tb
	 *
	 */
	public class TmfByteArray extends ByteArray
	{
		public function TmfByteArray(data:IDataInput)
		{
			data.readBytes(this, bytesAvailable);
		}
	}
}