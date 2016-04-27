package data
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import manager.LoadingManager;
	import manager.loading.ILoading;
	
	import com.lilynumber1.utils.DisplayUtil;
	
	import util.Logger;

	public class UILoader extends EventDispatcher
	{
		private var _loadingView:ILoading;

		private var _autoCloseLoading:Boolean;

		/**
		 * 用于添加显示对象的父容器
		 */
		private var _parent:DisplayObjectContainer;
		private var _url:String;
		/**
		 * 用于加载的loader对象
		 */
		private var _loader:Loader;
		private var _isCurrentApp:Boolean;
		private var _isLoading:Boolean = false;

		public function UILoader(url:String = "", parent:DisplayObjectContainer = null, loadingType:int = -1, loadingTitle:String = "", autoCloseLoading:Boolean = true, isCurrentApp:Boolean = false)
		{
			_isCurrentApp = isCurrentApp;
			_url = url;
			_parent = parent;
			_autoCloseLoading = autoCloseLoading;
			//
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, onOpenHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			//
			_loadingView = LoadingManager.getLoading(loadingType, parent, loadingTitle);
			_loadingView.addEventListener(Event.CLOSE, onLoadingCloseHandler);
		}

		//--------------------------------------------------------------
		// get set
		//--------------------------------------------------------------

		/**
		 *
		 * @return
		 *
		 */
		public function get loading():ILoading
		{
			return _loadingView;
		}

		/**
		 * 获取loader
		 * @return
		 *
		 */
		public function get loader():Loader
		{
			return _loader;
		}

		/**
		 *
		 * @param i
		 *
		 */
		public function set parent(i:DisplayObjectContainer):void
		{
			_parent = i;
		}

		public function get parent():DisplayObjectContainer
		{
			return _parent;
		}

		public function set closeEnabled(b:Boolean):void
		{
			_loadingView.closeEnabled = b;
		}

		public function get sharedEvents():EventDispatcher
		{
			return _loader.contentLoaderInfo.sharedEvents;
		}

		public function get content():DisplayObject
		{
			return _loader.content;
		}

		//--------------------------------------------------------------
		// public function
		//--------------------------------------------------------------

		/**
		 * 加载资源
		 * @param url 新资源的地址，默认不传就加载由构造函数中传来的资源地址
		 *
		 */
		public function load(url:String = ""):void
		{
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			if (_isCurrentApp)
			{
				context.applicationDomain = ApplicationDomain.currentDomain;
			}
			if (url != "")
			{
				_url = url;
			}
			if (_url != "")
			{
				_loader.load(new URLRequest(_url), context);
				_isLoading = true;
			}
		}

		public function close():void
		{
			if(_loader.content is MovieClip)
			{
				DisplayUtil.stopAllMovieClip(_loader.content as DisplayObjectContainer);
			}
			_isLoading = false;
			_loadingView.hide();
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
			}
			dispatchEvent(new UILoadEvent(UILoadEvent.CLOSE, this));
		}

		/**
		 * @param forceGC 强制清除loader里面的类
		 */
		public function destroy(forceGC:Boolean= false):void
		{
			
			close();
			//
			_loader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpenHandler);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler)
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler)
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			if(forceGC)
			{
				_loader.unloadAndStop();
			}
			//
			_loadingView.removeEventListener(Event.CLOSE, onLoadingCloseHandler);
			_loadingView.destroy();
			_loadingView = null;
			_parent = null;
			_loader = null;
		}

		//--------------------------------------------------------------
		// event
		//--------------------------------------------------------------

		private function onOpenHandler(e:Event):void
		{
			_loadingView.show();
			dispatchEvent(new UILoadEvent(UILoadEvent.OPEN, this));
		}

		private function onCompleteHandler(e:Event):void
		{
			_isLoading = false;
			if (_autoCloseLoading)
			{
				_loadingView.hide();
			}
			dispatchEvent(new UILoadEvent(UILoadEvent.COMPLETE, this));
		}

		private function onErrorHandler(e:IOErrorEvent):void
		{
			_isLoading = false;
			dispatchEvent(e);
			Logger.error(this, "加载出错！" + _url);
		}

		private function onProgressHandler(e:ProgressEvent):void
		{
			_loadingView.setPercent(e.bytesLoaded, e.bytesTotal);
		}

		private function onLoadingCloseHandler(e:Event):void
		{
			close();
		}

		public function get url():String
		{
			return _url;
		}
	}
}
