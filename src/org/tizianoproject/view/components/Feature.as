package org.tizianoproject.view.components
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Feature extends MovieClip
	{
		//These Positions are Relative to ArticleView
		private static const DEFAULT_X_POS:Number = 555;
		private static const DEFAULT_Y_POS:Number = 73;
		
		public var title_txt:TextField;
		public var subhed_txt:TextField;
		
		public var image_mc:MovieClip;
		public var authorType_mc:MovieClip;
		
		public function Feature()
		{
			x = DEFAULT_X_POS;
			buttonMode = true;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			title_txt.mouseEnabled = false;
			subhed_txt.mouseEnabled = false;
			image_mc.mouseEnabled = false;
			
			addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			//trace( "Feature::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "Feature::onRemovedFromStageHandler:" );
			ShowHideManager.unloadContent( (this as Feature ) );
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			trace( "Feature::onMouseClickHandler:", e.currentTarget.name );			
		}
		
		public function set yPos( value:Number ):void
		{
			y = DEFAULT_Y_POS + value;
		}
		
		public function set authorType( isMentor:Boolean ):void
		{
			if( isMentor ) authorType_mc.gotoAndStop( "mentor" );
			else authorType_mc.gotoAndStop( "student" );
		}		
	}
}
