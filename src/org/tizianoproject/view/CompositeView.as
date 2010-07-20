package org.tizianoproject.view
{	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class CompositeView extends MovieClip
	{		
		public function CompositeView()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.ADDED, onAddedHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		protected function init():void
		{
		}
		
		protected function unload():void
		{
			
		}		

		/**********************************
		 * Event Handlers
		 **********************************/
		protected function onAddedHandler( e:Event ):void
		{
			//trace( "CompositeView::onAddedHandler:", e.target );
		}

		protected function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
		
		protected function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
		}		
				
	}
}