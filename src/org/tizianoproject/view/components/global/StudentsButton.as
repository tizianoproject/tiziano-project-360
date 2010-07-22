package org.tizianoproject.view.components.global
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StudentsButton extends SimpleButton
	{
		public function StudentsButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			//trace( "StudentsButton::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "StudentsButton::onAddedToStageHandler:" );
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "StudentsButton::onMouseClickHandler:" );			
		}

	}
}