package com.chrisaiv.utils
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextFormatter
	{
		public function TextFormatter()
		{
		}
		
		public static function returnCSS( family:String="Georgia", color:String="#ffffff", size:Number=13  ):StyleSheet
		{
			var a:Object = new Object();
				a.color = color;
				a.fontSize = size;
				a.fontFamily = family;
				a.textDecoration = "none";

			var aHover:Object = new Object();
				aHover.textDecoration = "underline";	
			
			var css = new StyleSheet();
				css.setStyle("a", a);
				css.setStyle("a:hover", aHover);
			
			return css;			
		}
		
		public static function returnTextFormat( family:String="Georgia", color:Number=0xffffff, size:Number=12, leading:Number = 2  ):TextFormat
		{
			var tFormat:TextFormat = new TextFormat()
				tFormat.color = color;
				tFormat.size = size;
				tFormat.align = TextFormatAlign.LEFT;
				tFormat.font = family;
				tFormat.leading = leading;
				
				return tFormat;
		}

	}
}