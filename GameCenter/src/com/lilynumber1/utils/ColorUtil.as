package com.lilynumber1.utils
{

	/**
	 * 颜色功能
	 * @author tb
	 *
	 */
	public class ColorUtil
	{
		public static const RGB_MAX:uint = 256;
		public static const HUE_MAX:uint = 360;
		public static const PCT_MAX:uint = 100;
		
		/**
		 * 获取颜色数据中的透明度值 
		 * @param c
		 * @return 
		 * 
		 */		
		public static function getAlpha(c:uint):uint
		{
			return c >> 24 & 0xFF;
		}
		
		/**
		 * 获取颜色数据中的R值
		 * @param c
		 * @return 
		 * 
		 */		
		public static function getRed(c:uint):uint
		{
			return c >> 16 & 0xFF;
		}
		/**
		 * 获取颜色数据中的G值
		 * @param c
		 * @return 
		 * 
		 */		
		public static function getGreen(c:uint):uint
		{
			return c >> 8 & 0xFF;
		}
		
		/**
		 * 获取颜色数据中的B值
		 * @param c
		 * @return 
		 * 
		 */	
		public static function getBlue(c:uint):uint
		{
			return c & 0xFF;
		}
		
		/**
		 * 用rgb值创建一个24位颜色 
		 * @param r
		 * @param g
		 * @param b
		 * @return 
		 * 
		 */		
		public static function getColor24(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}
		
		/**
		 * 用argb值创建一个32位颜色 
		 * @param a
		 * @param r
		 * @param g
		 * @param b
		 * @return 
		 * 
		 */		
		public static function getColor32(a:uint, r:uint, g:uint, b:uint):uint
		{
			return a << 24 | r << 16 | g << 8 | b;
		}

		public static function HueToRGB(min:Number, max:Number, hue:Number):Object
		{
			var mu:Number, md:Number, F:Number, n:int;
			while (hue < 0)
			{
				hue += HUE_MAX;
			}
			n = int(hue / 60);
			F = (hue - n * 60) / 60;
			n %= 6;

			mu = min + ((max - min) * F);
			md = max - ((max - min) * F);

			switch (n)
			{
				case 0:
					return {r: max, g: mu, b: min};
				case 1:
					return {r: md, g: max, b: min};
				case 2:
					return {r: min, g: max, b: mu};
				case 3:
					return {r: min, g: md, b: max};
				case 4:
					return {r: mu, g: min, b: max};
				case 5:
					return {r: max, g: min, b: md};
			}
			return null;
		}

		public static function RGBToHue(red:Number, green:Number, blue:Number):uint
		{
			var f:Number, min:Number, mid:Number, max:Number, n:Number;

			max = Math.max(red, Math.max(green, blue));
			min = Math.min(red, Math.min(green, blue));

			// achromatic case
			if (max - min == 0)
			{
				return 0;
			}

			mid = center(red, green, blue);

			// using this loop to avoid super-ugly nested ifs
			while (true)
			{
				if (red == max)
				{
					if (blue == min)
						n = 0;
					else
						n = 5;
					break;
				}

				if (green == max)
				{
					if (blue == min)
						n = 1;
					else
						n = 2;
					break;
				}

				if (red == min)
					n = 3;
				else
					n = 4;
				break;
			}

			if ((n % 2) == 0)
			{
				f = mid - min;
			}
			else
			{
				f = max - mid;
			}
			f = f / (max - min);

			return 60 * (n + f);
		}

		public static function RGBtoHSL(red:Number, green:Number, blue:Number):Object
		{
			var min:Number, max:Number, delta:Number, l:Number, s:Number, h:Number = 0;

			max = Math.max(red, Math.max(green, blue));
			min = Math.min(red, Math.min(green, blue));

			//l = (min + max) / 2;
			l = (min + max) * 0.5;
			// L
			if (l == 0)
			{
				return {h: h, l: 0, s: 1};
			}

			//delta = (max - min) / 2;
			delta = (max - min) * 0.5;

			if (l < 0.5)
			{
				// S
				s = delta / l;
			}
			else
			{
				s = delta / (1 - l);
			}
			// H
			h = RGBToHue(red, green, blue);

			return {h: h, l: l, s: s};
		}

		public static function HSLtoRGB(hue:Number, luminance:Number, saturation:Number):Object
		{
			var delta:Number;
			if (luminance < 0.5)
			{
				delta = saturation * luminance;
			}
			else
			{
				delta = saturation * (1 - luminance);
			}
			return HueToRGB(luminance - delta, luminance + delta, hue);
		}

		public static function RGBtoHSV(red:Number, green:Number, blue:Number):Object
		{
			var min:Number, max:Number, s:Number, v:Number, h:Number = 0;

			max = Math.max(red, Math.max(green, blue));
			min = Math.min(red, Math.min(green, blue));

			if (max == 0)
			{
				return {h: 0, s: 0, v: 0};
			}

			v = max;
			s = (max - min) / max;

			h = RGBToHue(red, green, blue);

			return {h: h, s: s, v: v};
		}

		public static function HSVtoRGB(hue:Number, saturation:Number, value:Number):Object
		{
			var min:Number = (1 - saturation) * value;

			return HueToRGB(min, value, hue);
		}

		public static function HSVtoHSL(hue:Number, saturation:Number, value:Number):Object
		{
			var rgbVal:Object = HSVtoRGB(hue, saturation, value);
			return RGBtoHSL(rgbVal.r, rgbVal.g, rgbVal.b);
		}

		public static function HSLtoHSV(hue:Number, luminance:Number, saturation:Number):Object
		{
			var rgbVal:Object = HSLtoRGB(hue, luminance, saturation);
			return RGBtoHSV(rgbVal.r, rgbVal.g, rgbVal.b);
		}

		private static function center(a:Number, b:Number, c:Number):Number
		{
			if ((a > b) && (a > c))
			{
				if (b > c)
					return b;
				else
					return c;
			}
			else if ((b > a) && (b > c))
			{
				if (a > c)
					return a;
				else
					return c;
			}
			else if (a > b)
			{
				return a;
			}
			else
			{
				return b;
			}
		}
	}
}