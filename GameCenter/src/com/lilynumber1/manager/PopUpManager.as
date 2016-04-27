package com.lilynumber1.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.lilynumber1.utils.DisplayUtil;

	/**
	 * 弹出面板管理
	 * @author tb
	 *
	 */
	public class PopUpManager
	{
		public static const TOP_LEFT:int = 0;
		public static const TOP_RIGHT:int = 1;
		public static const BOTTOM_LEFT:int = 2;
		public static const BOTTOM_RIGHT:int = 3;

		public static var container:DisplayObjectContainer = LilyManager.stage;

		public function PopUpManager()
		{
		}

		/**
		 * 显示于某个显示对象旁边
		 * @param obj -- 弹出窗口显示对象
		 * @param forObj  -- 位于的显示对象
		 * @param isCountForObj  是否计算位于的显示对象的范围
		 * @param align -- 显示对齐位置
		 * @param offx -- x轴偏移
		 * @param offy -- y轴偏移
		 *
		 */
		public static function showForDisplayObject(obj:DisplayObject, forObj:DisplayObject, align:int = 0, isForObjRange:Boolean = true, offset:Point = null):void
		{
			var p:Point;
			if (offset)
			{
				p = forObj.localToGlobal(offset);
			}
			else
			{
				p = forObj.localToGlobal(new Point());
			}


			switch (align)
			{
				case TOP_LEFT:
					obj.x = p.x - obj.width;
					obj.y = p.y - obj.height;
					break;
				case TOP_RIGHT:
					if (isForObjRange)
					{
						obj.x = p.x + forObj.width;
					}
					else
					{
						obj.x = p.x;
					}
					obj.y = p.y - obj.height;
					break;
				case BOTTOM_LEFT:
					obj.x = p.x - obj.width;
					if (isForObjRange)
					{
						obj.y = p.y + forObj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
				case BOTTOM_RIGHT:
					if (isForObjRange)
					{
						obj.x = p.x + forObj.width;
					}
					else
					{
						obj.x = p.x;
					}
					if (isForObjRange)
					{
						obj.y = p.y + forObj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
			}
			container.addChild(obj);
//			container.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
//				{
//					if (!obj.hitTestPoint(e.stageX, e.stageY) && !forObj.hitTestPoint(e.stageX, e.stageY))
//					{
//						container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee);
//						DisplayUtil.removeForParent(obj);
//					}
//				});
		}

		/**
		 * 显示于鼠标旁边
		 * @param obj -- 弹出窗口显示对象
		 * @param align -- 显示对齐位置
		 * @param offx -- x轴偏移
		 * @param offy -- y轴偏移
		 *
		 */
		public static function showForMouse(obj:DisplayObject, align:int = 0, offx:int = 0, offy:int = 0):void
		{
			var p:Point = new Point(LilyManager.stage.mouseX + offx, LilyManager.stage.mouseY + offy);
			switch (align)
			{
				case TOP_LEFT:
					if (p.x > obj.width)
					{
						obj.x = p.x - obj.width;
					}
					else
					{
						obj.x = p.x;
					}
					if (p.y > obj.height)
					{
						obj.y = p.y - obj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
				case TOP_RIGHT:
					if (p.x+obj.width > LilyManager.stage.stageWidth)
					{
						obj.x = p.x - obj.width;
					}
					else
					{
						obj.x = p.x;
					}
					if (p.y > obj.height)
					{
						obj.y = p.y - obj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
				case BOTTOM_LEFT:
					if (p.x > obj.width)
					{
						obj.x = p.x - obj.width;
					}
					else
					{
						obj.x = p.x;
					}
					if (p.y+obj.height > LilyManager.stageHeight)
					{
						obj.y = p.y - obj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
				case BOTTOM_RIGHT:
					if (p.x+obj.width > LilyManager.stageWidth)
					{
						obj.x = p.x - obj.width;
					}
					else
					{
						obj.x = p.x;
					}
					if (p.y+obj.height > LilyManager.stageHeight)
					{
						obj.y = p.y - obj.height;
					}
					else
					{
						obj.y = p.y;
					}
					break;
			}
			container.addChild(obj);
			container.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					if (!obj.hitTestPoint(e.stageX, e.stageY))
					{
						container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee);
						DisplayUtil.removeForParent(obj);
					}
				});
		}
	}
}