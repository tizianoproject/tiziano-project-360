package com.chrisaiv.utils
{
	import flash.display.DisplayObject;
	
	public class Align
	{		
		
		public function Align()
		{
			
		}
		
		public static function toCenter( obj:DisplayObject ):void
		{
			obj.x = obj.stage.stageWidth / 2 - obj.width / 2;
			obj.y = obj.stage.stageHeight / 2 - obj.height / 2;
		}
		
		public static function toTopLeft( obj:DisplayObject ):void
		{
			obj.x = obj.stage.x;
			obj.y = obj.stage.y;
		}
		
		public static function toTopCenter( obj:DisplayObject ):void
		{
			obj.x = obj.stage.stageWidth / 2 - obj.width / 2;
			obj.y = obj.stage.y;			
		}
		
		public static function toTopRight( obj:DisplayObject ):void
		{
			obj.x = obj.stage.stageWidth - obj.width;
			obj.y = obj.stage.y;
		}
		
		public static function toBottomRight( obj:DisplayObject ):void
		{
			obj.x = obj.stage.stageWidth - obj.width;
			obj.y = obj.stage.stageHeight - obj.height;
		}
		
		public static function toBottomCenter( obj:DisplayObject ):void
		{
			obj.x = obj.stage.stageWidth / 2 - obj.width / 2;
			obj.y = obj.stage.stageHeight - obj.height;
		}
		
		public static function toBottomLeft( obj:DisplayObject ):void
		{
			obj.x = obj.stage.x;
			obj.y = obj.stage.stageHeight - obj.height;
		}
	}
}