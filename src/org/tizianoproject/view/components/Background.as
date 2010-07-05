//http://www.senocular.com/?entry=476
package org.tizianoproject.view.components
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.profiler.showRedrawRegions;
	
	public class Background extends MovieClip
	{
		private static const MIN_WIDTH:Number = 1024;
		private static const MIN_HEIGHT:Number = 768;
		
		private var defaultWidth:Number;
		private var defaultHeight:Number;
		private var browserWidth:Number;
		private var browserHeight:Number;
		private var aspectRatio:Number;
				
		private var defaultBitmap:Bitmap;
		private var regularBitmap:Bitmap;
		private var largeBitmap:Bitmap;

		private var bmpData:BitmapData;
		
		public function Background()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true );
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		private function init( ):void
		{
			defaultBitmap = getChildAt( 0 ) as Bitmap;
			defaultWidth = defaultBitmap.width;
			defaultHeight = defaultBitmap.height;
			aspectRatio = defaultWidth / defaultHeight;
		}

		private function createBitmap( newBitmap:Bitmap, bmpName:String, w:Number, h:Number, visible:Boolean=false, smooth:Boolean=false ):void
		{			
			bmpData = new BitmapData( defaultWidth, defaultHeight );
			bmpData.draw( defaultBitmap );
			
			newBitmap = new Bitmap( bmpData );
			newBitmap.name = bmpName;
			newBitmap.width = w;
			newBitmap.height = h;
			newBitmap.smoothing = smooth;
			//trace( newBitmap, bmpName, w, h , defaultWidth, defaultHeight);
			newBitmap.visible = visible;
			ShowHideManager.addContent( (this as Background), newBitmap );
		}
		
		private function removeBitmap( name:String ) :void
		{
			var childName:String = name;
			var container:MovieClip = (this as Background);

			if( container.getChildByName( childName ) != null){
				//Next check if it's currently visible. If it is, then remove it from the stage
				if( container.getChildByName( childName ).visible ){
					//Destroy the BitmapData and lower the memory
					Bitmap( container.getChildByName( childName ) ).bitmapData.dispose();
					container.removeChild( container.getChildByName( childName ) );					
				}
			}			  
		}
		
		private function adjustSize( w:Number, h:Number ):void
		{
			if( w > MIN_WIDTH ){
				width = w;
				height = w / aspectRatio;
				//Keep track of the Browser Window
				browserWidth = w;
				browserHeight = h;
			} else {				
				/*
				width = MIN_WIDTH;
				height = MIN_HEIGHT / aspectRatio;
				
				browserWidth = MIN_WIDTH;
				browserHeight = MIN_HEIGHT;
				*/
			}
		}

		/**********************************
		 * Event
		 **********************************/		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "Background::swfSizerHandler:", e.type, e.windowWidth, e.windowHeight );
			adjustSize( e.windowWidth, e.windowHeight );
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			trace( "Background::onFullScreenHandler:", e.fullScreen, w, h );
			
			if( e.fullScreen ){
				width = w;
				height = w / aspectRatio;
			} else {
				adjustSize( browserWidth, browserHeight );
			}
		}
				
		private function addedToStageHandler( e:Event ):void
		{
			//trace( "HeaderView::addedToStageHandler:" );
			init();
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			trace( "HeaderView::removedFromStageHandler:" );
		}
		
	}
}