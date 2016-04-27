package manager.popup
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    import manager.LayerManager;
    
    import model.BaseViewModule;
    
    import com.lilynumber1.utils.DisplayUtil;

	/**
	 * 弹框管理
	 */
    public class PopUpManager
    {
        private static var _instance:PopUpManager;

        public static function get instance():PopUpManager
        {
            return _instance ||= new PopUpManager();
        }

		/**
		 * 抓取的屏幕截图
		 */
		private var _catchBmp:Bitmap;

        private var _darkLayer:Sprite;

        private var _map:Vector.<BaseViewModule>;
		
		private var _catchModule:BaseViewModule;
		
		//private var _catchCount:int = 0;
		/**
		 * 捕捉截图的集合
		 */
		//private var _catchMap:Vector.<BaseViewModule> = new Vector.<BaseViewModule>;

        public function PopUpManager()
        {
            _darkLayer = new Sprite();
            _darkLayer.graphics.beginFill(0, .6);
            _darkLayer.graphics.drawRect(0, 0, LayerManager.MAX_WIDTH, LayerManager.MAX_HEIGHT);
            _darkLayer.graphics.endFill();

            _map = new Vector.<BaseViewModule>();
        }
		
		/**
		 * 接取屏幕
		 */
		public function catchScreen(module:BaseViewModule):void
		{
			/**
			 * 只截取一次
			 */
			if(module.modalType != ModalType.NONE)
			{
				//_catchCount++;
				if (_catchBmp == null)
				{
					_catchModule = module;
					var bitmapData:BitmapData = new BitmapData(LayerManager.stageWidth,LayerManager.stageHeight);
					bitmapData.draw(LayerManager.root,null,null,null,new Rectangle(-LayerManager.root.x,-LayerManager.root.y,LayerManager.stageWidth,LayerManager.stageHeight));
					
					var blurFilter:BlurFilter = new BlurFilter(4,4);
					
					_catchBmp = new Bitmap;
					_catchBmp.bitmapData = bitmapData;
					_catchBmp.filters = [blurFilter];
					
					var index:int = LayerManager.root.getChildIndex(LayerManager.topLevel);
					LayerManager.root.addChildAt(_catchBmp,index);
					
	//				DisplayUtil.removeForParent(LayerManager.mapLevel,false);
	//				DisplayUtil.removeForParent(LayerManager.toolUiLevel,false);
	//				DisplayUtil.removeForParent(LayerManager.uiLevel,false);
	//				DisplayUtil.removeForParent(LayerManager.toolsLevel,false);
	//				DisplayUtil.removeForParent(LayerManager.gameLevel,false);
					LayerManager.mapLevel.visible = false;
					LayerManager.toolUiLevel.visible = false;
					LayerManager.uiLevel.visible = false;
					LayerManager.toolsLevel.visible = false;
					LayerManager.gameLevel.visible = false;
				}
			}
		}

        public function add(module:BaseViewModule):void
        {
            if (module.modalType != ModalType.NONE && _map.indexOf(module) == -1)
            {
                _map.push(module);
				reset();
            }
        }

        public function remove(module:BaseViewModule):void
        {
			if(module.modalType != ModalType.NONE)
			{
				//_catchBmp && (
				//_catchCount--;
				if (_catchModule == module && _catchBmp)
				{
					_catchModule = null;
					_catchBmp.bitmapData.dispose();
					DisplayUtil.removeForParent(_catchBmp);
					LayerManager.mapLevel.visible = true;
					LayerManager.toolUiLevel.visible = true;
					LayerManager.uiLevel.visible = true;
					LayerManager.toolsLevel.visible = true;
					LayerManager.gameLevel.visible = true;
					_catchBmp = null;
				}
				
			}
			
			var index:int = _map.indexOf(module);
			if(module.modalType != ModalType.NONE && index != -1)
			{
				_map.splice(index, 1);
				reset();
			}
			
        }

        private function reset():void
        {
			var darkIndex:int = -1;
			var len:int = _map.length;
			var module:BaseViewModule;
			while(--len >= 0)
			{
				module = _map[len];
				if (module.modalType == ModalType.DARK && module.sprite && module.sprite.parent)
				{
					darkIndex = len;
					break;
				}
			}
			
			if (_darkLayer.parent)
			{
				_darkLayer.parent.removeChild(_darkLayer);
			}
			
            if (darkIndex != -1)
            {
				LayerManager.topLevel.addChildAt(_darkLayer, module.sprite.parent.getChildIndex(module.sprite));
            }
        }
    }
}