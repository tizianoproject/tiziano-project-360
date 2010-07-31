package org.tizianoproject.view.components
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import org.tizianoproject.view.CompositeView;
	
	public class Mask extends CompositeView
	{
		public function Mask()
		{
		}
		
		override protected function init():void
		{
			graphics.beginFill( 0xFF00FF, 0 );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
		}
		
		override protected function unload():void
		{
			graphics.clear();
		}
		//Update the Mask that prevents the Wall Tiles from Activating
		public function updateSize( w:Number, h:Number ):void
		{
			width = w;
			height = h;
		}
	}
}