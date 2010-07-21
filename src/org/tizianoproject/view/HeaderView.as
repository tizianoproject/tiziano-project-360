package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import org.tizianoproject.view.components.global.MentorsButton;
	import org.tizianoproject.view.components.global.StudentsButton;
	
	public class HeaderView extends CompositeView
	{
		private static const DEFAULT_BG_COLOR:Number = 0x000000;
		private static const DEFAULT_BG_ALPHA:Number = 0.5;
		private static const DEFAULT_HEIGHT:Number = 70;

		private static const MIN_WIDTH:Number = 450;
		private static const MARGIN_RIGHT:Number = 20;
		
		private var bg:Sprite;
		private var browserWidth:Number;

		public var headerRight_mc:MovieClip;
		private var studentsView:StudentsButton;
		private var mentorsView:MentorsButton;
		
		public function HeaderView(  )
		{
			//Assign Target
			mentorsView = headerRight_mc.mentorsView;
			studentsView = headerRight_mc.studentsView;
		}

		/**********************************
		 * 
		 **********************************/
		override protected function init():void
		{
			initBackground();
			mentorsView.addEventListener(MouseEvent.CLICK, onMentorClickHandler, false, 0, true );
			studentsView.addEventListener(MouseEvent.CLICK, onMentorClickHandler, false, 0, true );
		}
		
		private function onMentorClickHandler( e:MouseEvent ):void
		{
			dispatchEvent( e );
		}
		
		private function updateBackground( value:Number ):void
		{
			//trace( "HeaderView::resizeBackground:", value );
			bg.width = value;
		}
		
		private function updatePosition( value:Number ):void
		{
			if( value > MIN_WIDTH ){
				headerRight_mc.x = value - MARGIN_RIGHT;
			} else {
				headerRight_mc.x = MIN_WIDTH - MARGIN_RIGHT;				
			}
		}
		
		override protected function resize( ):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			//trace( "Background::onFullScreenHandler:", w, h );			
			if( stage.displayState == StageDisplayState.FULL_SCREEN ){
				updatePosition( stage.stageWidth - headerRight_mc.width );
				updateBackground( stage.stageWidth );
			} else {
				updatePosition( browserWidth - headerRight_mc.width );
				updateBackground( browserWidth );
			}
		}		
		
		/**********************************
		 * 
		 **********************************/
		private function initBackground():void
		{
			bg = new Sprite();
			bg.name = "bg";
			bg.mouseChildren = true;
			bg.mouseEnabled = false;
			
			bg.graphics.beginFill( DEFAULT_BG_COLOR, DEFAULT_BG_ALPHA );
			bg.graphics.drawRect( 0, 0, stage.stageWidth, DEFAULT_HEIGHT );
			bg.graphics.endFill();
			
			bg.graphics.lineStyle(1, 0x666666, 1 );
			bg.graphics.moveTo( 0, DEFAULT_HEIGHT );
			bg.graphics.lineTo( stage.stageWidth, DEFAULT_HEIGHT );
			
			addChildAt( bg, 0 );			
		}

		/**********************************
		 * Event
		 **********************************/		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "HeaderView::swfSizerHandler:", e.topY, e.bottomY, e.leftX, e.rightX, e.windowWidth, e.windowHeight );
			browserWidth = e.rightX;
			
			updatePosition( browserWidth - headerRight_mc.width );
			updateBackground( browserWidth );
		}		
	}
}