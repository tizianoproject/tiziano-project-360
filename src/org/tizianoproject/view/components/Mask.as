package org.tizianoproject.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Mask extends Sprite
	{
		public function Mask()
		{
			 addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			 addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			graphics.beginFill( 0xFF00FF, 1 );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
			
			addEventListener( MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			trace( "MaskView::removedFromStageHandler:" );
		}
		
		private function onMouseClickHandler( e:Event ):void
		{
			trace( "MaskView::onMouseClickHandler:" );
		}
	}
}