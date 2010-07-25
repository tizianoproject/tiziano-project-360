package org.tizianoproject.view
{	
	import com.chargedweb.swfsize.SWFSize;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FullScreenEvent;

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
		
		protected function resize( ):void
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
			//You Must first wait for the View to be loaded before you can activate the stage listener
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		protected function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
		}		
		
		protected function onFullScreenHandler( e:FullScreenEvent ):void
		{
			resize( );
		}
				
	}
}