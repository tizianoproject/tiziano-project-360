package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.tizianoproject.events.BaseViewEvent;
	
	public class InfoView extends CompositeView
	{
		//This is the Default Width + Close Button
		private static const MIN_WIDTH:Number = 900;
		//This is the Default Height
		private static const MIN_HEIGHT:Number = 600;
		
		private static const DEFAULT_POS:Point = new Point( 0, 71 );
		
		private static const URL:String = "http://www.tizianoproject.org";
		
		private var browserWidth:Number;
		private var browserHeight:Number;
		
		public var baseView_mc:BaseView;
		public var url_txt:TextField;		
		
		public function InfoView()
		{
		}
		
		override protected function init():void
		{
			updatePosition();
			
			url_txt.htmlText = "<a href='" + URL + "' target='_blank'>www.TizianoProject.org</a>";
			url_txt.addEventListener(TextEvent.LINK, onTextLinkHandler, false, 0, true );			

			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );
		}
		
		private function onTextLinkHandler( e:TextEvent ):void
		{
			trace( "InfoView::onTextLinkHandler:", e.text );
		}
		
		/**********************************
		 * Resize
		 **********************************/
		override public function browserResize(e:SWFSizeEvent):void
		{
			browserWidth = e.rightX;
			browserHeight = e.bottomY;
			//trace( "DirectoryView::browserResize:", browserWidth, browserHeight );
			
			if( stage ) updatePosition();			
		}
		
		override protected function resize(e:FullScreenEvent):void
		{
			if( stage ) updatePosition();
		}

		private function updatePosition(  ):void
		{
			if( stage.displayState == StageDisplayState.FULL_SCREEN ){
				x = stage.fullScreenWidth / 2 - ( MIN_WIDTH / 2 );
				y = stage.fullScreenHeight / 2 - ( MIN_HEIGHT / 2 );
			} else {
				//trace( "ArticleView::updatePosition:", browserWidth, browserHeight );
				if( browserWidth && browserHeight ){
					var dynWidth:Number = ( browserWidth > MIN_WIDTH) ? browserWidth : MIN_WIDTH;
					x = ( dynWidth / 2) - ( MIN_WIDTH / 2 );
					
					var dynHeight:Number = ( browserHeight > MIN_HEIGHT ) ? browserHeight : MIN_HEIGHT ;
					var yPos:Number = ( dynHeight / 2) - ( MIN_HEIGHT / 2 );
					y = ( yPos > + DEFAULT_POS.y ) ? yPos : DEFAULT_POS.y;					
				} else {
					x = ( stage.stageWidth / 2) - ( MIN_WIDTH / 2 );
					y = ( ( stage.stageHeight - DEFAULT_POS.y ) / 2) - ( MIN_HEIGHT / 2 ) + DEFAULT_POS.y;
				}
			}
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			dispatchEvent( e );
		}
	}
}