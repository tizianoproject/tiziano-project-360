package org.tizianoproject.view.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class FeatureHolder extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 530;
		private static const DEFAULT_Y_POS:Number = 73;
		private static const WIDTH:Number = 320;
		private static const HEIGHT:Number = 500;
		
		public function FeatureHolder()
		{
			tabEnabled = false;
			
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
			
			graphics.beginFill( 0xff00ff, 0 );
			graphics.drawRect( 0, 0, WIDTH, HEIGHT );
			graphics.endFill();
		}		
	}
}