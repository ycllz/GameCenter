package data
{
	public class WordConfig
	{
		public static var loading:Array = [];
		public static var map:Array = [];
		public static var tollgate:Array = [];
		
		private static const NODE:String = "node";
		public static function setup(xml:XML):void
		{
			var item:XML;
			var xmlList:XMLList;
			//
			xmlList = xml.elements("loading");
			xmlList = xmlList.elements(NODE);
			for each(item in xmlList)
			{
				loading.push(item.toString());
			}
			//
			xmlList = xml.elements("map");
			xmlList = xmlList.elements(NODE);
			for each(item in xmlList)
			{
				map.push(item.toString());
			}
			//
			xmlList = xml.elements("tollgate");
			xmlList = xmlList.elements(NODE);
			for each(item in xmlList)
			{
				tollgate.push(item.toString());
			}
		}
	}
}