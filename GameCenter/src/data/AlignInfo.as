package data
{

    /**
     * 对齐信息
     */
    public class AlignInfo
    {
        public var x:Number = NaN;

        public var y:Number = NaN;

        public var left:Number = NaN;

        public var right:Number = NaN;

        public var top:Number = NaN;

        public var bottom:Number = NaN;

        public var center:Boolean = false;

        public var middle:Boolean = false;
		
		public function AlignInfo(x:Number = NaN, 
								  	y:Number = NaN, 
									left:Number = NaN, 
									right:Number = NaN, 
									top:Number = NaN, 
									bottom:Number = NaN, 
									center:Boolean = false, 
									middle:Boolean = false)
		{
			this.x = x;
			this.y = y;
			this.left = left;
			this.right = right;
			this.top = top;
			this.bottom = bottom;
			this.center = center;
			this.middle = middle;
		}

        public static function getXPosition(containerWidth:Number, childWidth:Number, alignInfo:AlignInfo):Number
        {
            if (alignInfo.center)
            {
                return containerWidth - childWidth >> 1;
            }
            if (isNaN(alignInfo.x) == false)
            {
                return alignInfo.x;
            }
            if (isNaN(alignInfo.left) == false)
            {
                return alignInfo.left;
            }
            if (isNaN(alignInfo.right) == false)
            {
                return containerWidth - alignInfo.right;
            }
            return NaN;
        }

        public static function getYPosition(containerHeight:Number, childHeight:Number, alignInfo:AlignInfo):Number
        {
            if (alignInfo.middle)
            {
                return containerHeight - childHeight >> 1;
            }
            if (isNaN(alignInfo.y) == false)
            {
                return alignInfo.y;
            }
            if (isNaN(alignInfo.top) == false)
            {
                return alignInfo.top;
            }
            if (isNaN(alignInfo.bottom) == false)
            {
                return containerHeight - alignInfo.bottom;
            }
            return NaN;
        }
    }
}