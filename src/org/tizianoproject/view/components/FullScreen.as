package org.tizianoproject.view.components
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	
	public class FullScreen extends SimpleButton
	{
		private var appStage:Stage;
		
		public function FullScreen()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(MouseEvent.CLICK, goScaledFullScreen);
			addEventListener(MouseEvent.CLICK, toggleButtonHandler, false, 0, true );
			addEventListener(MouseEvent.MOUSE_OVER, toggleButtonHandler, false, 0, true );
			addEventListener(MouseEvent.MOUSE_OUT, toggleButtonHandler, false, 0, true );
			
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			appStage = stage;
		}

		private function goScaledFullScreen( e:MouseEvent ):void
		{
			trace("appStage.displayState: " + appStage.displayState );
			if(appStage.displayState == StageDisplayState.NORMAL) appStage.displayState = StageDisplayState.FULL_SCREEN;
			else appStage.displayState = StageDisplayState.NORMAL;
		}	
		
		private function toggleButtonHandler( e:MouseEvent ):void
		{
			trace(e.type);
			//trace(e.type, e.currentTarget.overState), e.currentTarget.downState, e.currentTarget.upState, e.currentTarget.hitTestState );
			/*
			if(e.type == "mouseOver")
				if(e.target.currentLabel == "play") e.target.gotoAndStop("playOver");
				else if (e.target.currentLabel == "pause") e.target.gotoAndStop("pauseOver");
			if(e.type == "mouseOut")
				if(e.target.currentLabel == "playOver") e.target.gotoAndStop("play");
				else if (e.target.currentLabel == "pauseOver") e.target.gotoAndStop("pause");
			if(e.type == "click")
				if (e.target.currentLabel == "playOver") e.target.gotoAndStop("pauseOver");
				else if (e.target.currentLabel == "pauseOver") e.target.gotoAndStop("playOver");			
			*/
		}

		
	}
}