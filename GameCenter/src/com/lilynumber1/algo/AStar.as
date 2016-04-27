package com.lilynumber1.algo
{
	import flash.geom.Point;

	/**
	 * A*寻路
	 * @author tb
	 *
	 */
	public class AStar
	{
		/**
		 *  一个点周围的8个点列表，p.add(aroundsData[i])这样获取
		 */		
		public static const aroundsData:Array = [new Point(1, 0), new Point(0, 1), new Point(-1, 0), new Point(0, -1), new Point(1, 1), new Point(-1, 1), new Point(-1, -1), new Point(1, -1)];

		//横或竖向移动一格的路径评分
		private const COST_STRAIGHT:int = 10;
		//斜向移动一格的路径评分
		private const COST_DIAGONAL:int = 14;

		//(单个)节点数组 节点ID 索引
		private const NOTE_ID:int = 0;
		//(单个)节点数组 是否在开启列表中 索引
		private const NOTE_OPEN:int = 1;
		//(单个)节点数组 是否在关闭列表中 索引
		private const NOTE_CLOSED:int = 2;

		//地图模型
		private var _mapModel:IMapModel;

		//最大寻路步数，限制超时返回
		private var _maxTry:int;

		//
		//开放列表，存放节点ID
		private var _openList:Array;
		//开放列表长度
		private var _openCount:int;
		//节点加入开放列表时分配的唯一ID(从0开始)
		//根据此ID(从下面的列表中)存取节点数据
		private var _openId:int;
		//节点坐标列表
		private var _nodeList:Array;
		//节点路径评分列表
		private var _pathScoreList:Array;
		//(从起点移动到)节点的移动耗费列表
		private var _movementCostList:Array;
		//节点的父节点(ID)列表
		private var _fatherList:Array;

		//节点(数组)地图,根据节点坐标记录节点开启关闭状态和ID
		private var _noteMap:Array;

		//--------------------------------------------------
		// Constructor
		//--------------------------------------------------

		public function AStar()
		{
		}

		/**
		 * 单例
		 */
		private static var _instance:AStar;

		private static function getInstance():AStar
		{
			if (_instance == null)
			{
				_instance = new AStar();
			}
			return _instance;
		}

		//--------------------------------------------------
		// public static function
		//--------------------------------------------------
		
		/**
		 * 初始化寻路数据 
		 * @param mapModel 地图模型
		 * @param maxTry   最大寻路步数
		 * 
		 */		
		public static function init(mapModel:IMapModel, maxTry:int = 1000):void
		{
			getInstance()._mapModel = mapModel;
			getInstance()._maxTry = maxTry;
		}
		
		/**
		 * 开始寻找路径 
		 * @param p_start 开始点
		 * @param p_end   终点
		 * @return        路径数组
		 * 
		 */		
		public static function find(p_start:Point, p_end:Point):Array
		{
			return getInstance()._find(p_start, p_end);
		}
		
		/**
		 * 获取当前设置的最大寻路步数，限制超时返回
		 * @return 
		 * 
		 */		
		public static function get maxTry():int
		{
			return getInstance()._maxTry;
		}

		//--------------------------------------------------
		// public function
		//--------------------------------------------------

		/**
		 * 开始寻路
		 *
		 * @param p_start		起点坐标
		 * @param p_end 		终点坐标
		 *
		 * @return 				找到的路径(数组 : [Point], ... )
		 */
		private function _find(p_start:Point, p_end:Point):Array
		{
			if(_mapModel == null)
			{
				return null;
			}
			p_start = transPoint(p_start);
			var endPos:Point = transPoint(p_end.clone());

			if (!isBlock(endPos))
			{
				return null;
			}

			initLists();
			_openCount = 0;
			_openId = -1;

			openNote(p_start, 0, 0, 0);

			var currTry:int = 0;
			var currId:int;
			var currNoteP:Point;

			var checkingId:int;

			var cost:int;
			var score:int;

			while (_openCount > 0)
			{
				//超时返回
				if (++currTry > _maxTry)
				{
					destroyLists();
					return null;
				}
				//每次取出开放列表最前面的ID
				currId = _openList[0];
				//将编码为此ID的元素列入关闭列表
				closeNote(currId);

				currNoteP = _nodeList[currId];

				//如果终点被放入关闭列表寻路结束，返回路径
				if (endPos.equals(currNoteP))
				{
					return getPath(p_start, currId);
				}

				//获取周围节点，排除不可通过和已在关闭列表中的
				var aroundNotes:Array = getArounds(currNoteP);

				//对于周围的每一个节点
				for each (var note:Point in aroundNotes)
				{
					//计算F和G值
					cost = _movementCostList[currId] + ((note.x == currNoteP.x || note.y == currNoteP.y) ? COST_STRAIGHT : COST_DIAGONAL);
					score = cost + (Math.abs(endPos.x - note.x) + Math.abs(endPos.y - note.y)) * COST_STRAIGHT;

					if (isOpen(note))
					{
						//如果节点已在播放列表中
						checkingId = _noteMap[note.y][note.x][NOTE_ID];

						//如果新的G值比节点原来的G值小,修改F,G值，换父节点
						if (cost < _movementCostList[checkingId])
						{
							_movementCostList[checkingId] = cost;
							_pathScoreList[checkingId] = score;
							_fatherList[checkingId] = currId;
							aheadNote(_openList.indexOf(checkingId) + 1);
						}
					}
					else
					{
						//如果节点不在开放列表中
						//将节点放入开放列表
						openNote(note, score, cost, currId);
					}
				}
			}
			//开放列表已空，找不到路径
			destroyLists();
			return null;
		}

		//--------------------------------------------------
		// private function
		//--------------------------------------------------

		/**
		 * @private
		 * 将节点加入开放列表
		 *
		 * @param p		节点在地图中的x y坐标
		 * @param P_score	节点的路径评分
		 * @param p_cost	起始点到节点的移动成本
		 * @param p_fatherId	父节点
		 */
		private function openNote(p:Point, p_score:int, p_cost:int, p_fatherId:int):void
		{
			_openCount++;
			_openId++;

			if (_noteMap[p.y] == null)
			{
				_noteMap[p.y] = [];
			}
			_noteMap[p.y][p.x] = [];
			_noteMap[p.y][p.x][NOTE_OPEN] = true;
			_noteMap[p.y][p.x][NOTE_ID] = _openId;

			_nodeList.push(p);

			_pathScoreList.push(p_score);
			_movementCostList.push(p_cost);
			_fatherList.push(p_fatherId);

			_openList.push(_openId);
			aheadNote(_openCount);
		}

		/**
		 * @private
		 * 将节点加入关闭列表
		 */
		private function closeNote(p_id:int):void
		{
			_openCount--;
			var noteP:Point = _nodeList[p_id];

			_noteMap[noteP.y][noteP.x][NOTE_OPEN] = false;
			_noteMap[noteP.y][noteP.x][NOTE_CLOSED] = true;

			if (_openCount <= 0)
			{
				_openCount = 0;
				_openList = [];
				return;
			}
			_openList[0] = _openList.pop();
			backNote();
		}

		/**
		 * @private
		 * 将(新加入开放别表或修改了路径评分的)节点向前移动
		 */
		private function aheadNote(p_index:int):void
		{
			var father:int;
			var change:int;

			while (p_index > 1)
			{
				//父节点的位置
				father = int(p_index / 2);

				//如果该节点的F值小于父节点的F值则和父节点交换
				if (getScore(p_index) < getScore(father))
				{
					change = _openList[p_index - 1];
					_openList[p_index - 1] = _openList[father - 1];
					_openList[father - 1] = change;
					p_index = father;
				}
				else
				{
					break;
				}
			}
		}

		/**
		 * @private
		 * 将(取出开启列表中路径评分最低的节点后从队尾移到最前的)节点向后移动
		 */
		private function backNote():void
		{
			//尾部的节点被移到最前面
			var checkIndex:int = 1;
			var tmp:int;
			var change:int;

			while (true)
			{
				tmp = checkIndex;

				//如果有子节点
				if (2 * tmp <= _openCount)
				{

					//如果子节点的F值更小
					if (getScore(checkIndex) > getScore(2 * tmp))
					{
						//记节点的新位置为子节点位置
						checkIndex = 2 * tmp;
					}

					//如果有两个子节点
					if (2 * tmp + 1 <= _openCount)
					{

						//如果第二个子节点F值更小
						if (getScore(checkIndex) > getScore(2 * tmp + 1))
						{
							//更新节点新位置为第二个子节点位置
							checkIndex = 2 * tmp + 1;
						}
					}
				}

				//如果节点位置没有更新结束排序
				if (tmp == checkIndex)
				{
					break;
				}
				//反之和新位置交换，继续和新位置的子节点比较F值
				else
				{
					change = _openList[tmp - 1];
					_openList[tmp - 1] = _openList[checkIndex - 1];
					_openList[checkIndex - 1] = change;
				}
			}
		}

		/**
		 * @private
		 * 判断某节点是否在开放列表
		 */
		private function isOpen(p:Point):Boolean
		{

			if (_noteMap[p.y] == null)
			{
				return false;
			}

			if (_noteMap[p.y][p.x] == null)
			{
				return false;
			}
			return _noteMap[p.y][p.x][NOTE_OPEN];
		}

		/**
		 * @private
		 * 判断某节点是否在关闭列表中
		 */
		private function isClosed(p:Point):Boolean
		{

			if (_noteMap[p.y] == null)
			{
				return false;
			}
			if (_noteMap[p.y][p.x] == null)
			{
				return false;
			}
			return _noteMap[p.y][p.x][NOTE_CLOSED];
		}

		/**
		 * @private
		 * 获取某节点的周围节点，排除不能通过和已在关闭列表中的
		 */
		private function getArounds(p:Point):Array
		{
			var arr:Array = [];
			var checkP:Point;
			var canDiagonal:Boolean;
			var i:int = 0;

			//右
			checkP = p.add(aroundsData[i]);
			i++;
			var canRight:Boolean = isBlock(checkP);

			if (canRight && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//下
			checkP = p.add(aroundsData[i]);
			i++;
			var canDown:Boolean = isBlock(checkP);

			if (canDown && !isClosed(checkP))
			{
				arr.push(checkP);
			}

			//左
			checkP = p.add(aroundsData[i]);
			i++;
			var canLeft:Boolean = isBlock(checkP);

			if (canLeft && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//上
			checkP = p.add(aroundsData[i]);
			i++;
			var canUp:Boolean = isBlock(checkP);

			if (canUp && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//右下
			checkP = p.add(aroundsData[i]);
			i++;
			canDiagonal = isBlock(checkP);

			if (canDiagonal && canRight && canDown && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//左下
			checkP = p.add(aroundsData[i]);
			i++;
			canDiagonal = isBlock(checkP);

			if (canDiagonal && canLeft && canDown && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//左上
			checkP = p.add(aroundsData[i]);
			i++;
			canDiagonal = isBlock(checkP);

			if (canDiagonal && canLeft && canUp && !isClosed(checkP))
			{
				arr.push(checkP);
			}
			//右上
			checkP = p.add(aroundsData[i]);
			i++;
			canDiagonal = isBlock(checkP);

			if (canDiagonal && canRight && canUp && !isClosed(checkP))
			{
				arr.push(checkP);
			}

			return arr;
		}

		/**
		 * @private
		 * 获取路径
		 *
		 * @param p_start	起始点坐标
		 * @param p_id		终点的ID
		 *
		 * @return 			路径坐标(Point)数组
		 */
		private function getPath(p_start:Point, p_id:int):Array
		{
			var arr:Array = [];
			var noteP:Point = _nodeList[p_id];

			while (!p_start.equals(noteP))
			{
				arr.push(noteP);
				p_id = _fatherList[p_id];
				noteP = _nodeList[p_id];
			}
			arr.push(p_start);
			destroyLists();
			arr.reverse();

			//优化路径
			optimize(arr);

			arr.forEach(eachArray);
			return arr;
		}

		/**
		 * 还原数据内容
		 *
		 */
		private function eachArray(element:Point, index:int, arr:Array):void
		{
			element.x *= _mapModel.gridSize;
			element.y *= _mapModel.gridSize;
		}

		/**
		 * @private
		 * 获取某节点的路径评分
		 *
		 * @param p_index	节点在开启列表中的索引(从1开始)
		 */
		private function getScore(p_index:int):int
		{
			return _pathScoreList[_openList[p_index - 1]];
		}

		/**
		 * 是否为障碍
		 * @param p	坐标
		 * @return
		 */
		private function isBlock(p:Point):Boolean
		{
			if (p.x < 0 || p.x >= _mapModel.gridX || p.y < 0 || p.y >= _mapModel.gridY)
			{
				return false;
			}
			return _mapModel.data[p.x][p.y];
		}

		private function transPoint(p:Point):Point
		{
			p.x = int(p.x / _mapModel.gridSize);
			p.y = int(p.y / _mapModel.gridSize);
			return p;
		}

		/**
		 * @private
		 * 初始化数组
		 */
		private function initLists():void
		{
			_openList = [];
			_nodeList = [];
			_pathScoreList = [];
			_movementCostList = [];
			_fatherList = [];
			_noteMap = [];
		}

		/**
		 * @private
		 * 销毁数组
		 */
		private function destroyLists():void
		{
			_openList = null;
			_nodeList = null;
			_pathScoreList = null;
			_movementCostList = null;
			_fatherList = null;
			_noteMap = null;
		}

		/**
		 * 优化寻路路径 （寻直走点，消减能直走点之间的点）
		 * @param arr
		 * @param index
		 *
		 */
		private function optimize(arr:Array, index:int = 0):void
		{
			if (arr == null)
			{
				return;
			}

			var _nLen:int = arr.length - 1;

			if (_nLen < 2)
			{
				return;
			}

			var p1:Point = arr[index];
			var p2:Point;
			var dis:int;
			var angle:Number;
			var newArr:Array = [];
			for (var i:int = _nLen; i > index; i--)
			{
				p2 = arr[i];
				dis = Point.distance(p1, p2);
				angle = Math.atan2(p2.y - p1.y, p2.x - p1.x);

				for (var c:int = 1; c < dis; c++)
				{
					var checkP:Point = p1.add(Point.polar(c, angle));
					checkP.x = int(checkP.x);
					checkP.y = int(checkP.y);
					if (_mapModel.data[checkP.x][checkP.y])
					{
						newArr.push(checkP);
					}
					else
					{
						newArr = [];
						break;
					}
				}
				var w:int = newArr.length;
				if (w > 0)
				{
					arr.splice(index + 1, i - index - 1);
					index += w - 1;
					break;
				}
			}
			if (index < _nLen)
			{
				optimize(arr, ++index);
			}
		}
	}
}