package manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import manager.loading.EmptyLoading;
	import manager.loading.ILoading;
	import manager.loading.LoadingType;
	import manager.loading.TitlePercentLoading;
	
	import com.lilynumber1.utils.Utils;
	
	/**
	 * loading样式库。loading样式作为资源最初载入，因为在UI载入之前很多地方需要调用loading
	 * @author tb
	 * 
	 */	
	public class LoadingManager
	{
		private static var _loader:Loader;
		
		/**
		 * 设置加载UI的加载器
		 * 
		 */		
		public static function setup(loader:Loader):void
		{
			_loader = loader;
		}
		
		/**
		 * 获取加载器 
		 * @return 
		 * 
		 */		
		public static function get loader():Loader
		{
			return _loader;
		}
		
		/**
		 * 获取UI库中的MovieClip
		 * @param str
		 * @return
		 * 
		 */		
		public static function getMovieClip(str:String):MovieClip
		{
			return Utils.getMovieClipFromLoader(str,_loader);
		}
		
		/**
		 * 获取UI库中的Sprite
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getSprite(str:String):Sprite
		{
			return Utils.getSpriteFromLoader(str,_loader);
		}
		
		
		/**
		 * 获取loading实例
		 * @param style
		 * @param parent
		 * @param title
		 * @param closeEnabled
		 * @return 
		 * 
		 */		
		public static function getLoading(type:int,parent:DisplayObjectContainer,title:String="Loading...",closeEnabled:Boolean = false):ILoading
		{
			var _loading:ILoading;
			switch (type)
			{
				case LoadingType.NO_ALL:
					_loading = new EmptyLoading();
					break;
				case LoadingType.TITLE_AND_PERCENT:
					_loading = new TitlePercentLoading(parent,title,closeEnabled);
					break;
			}
			return _loading;
		}
	}
}