//http://www.senocular.com/?entry=476
package org.tizianoproject.view.components
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.profiler.showRedrawRegions;
	import flash.system.LoaderContext;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Background extends MovieClip
	{
		private static const DEFAULT_BG_IMAGE:String = "http://demo.chrisaiv.com/images/tiziano/360/wall/Wall-Bg.jpg"
		private static const MIN_WIDTH:Number = 800;
		private static const MIN_HEIGHT:Number = 600;
		
		private var defaultWidth:Number;
		private var defaultHeight:Number;
		private var browserWidth:Number;
		private var browserHeight:Number;
		private var aspectRatio:Number;
				
		private var loaderContext:LoaderContext;
		private var bitmap:Bitmap;
		private var bgLoader:Loader;		
		
		public function Background()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true );
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		private function init( ):void
		{
			loadBackground();
		}

		private function bitmapIsLoaded():Boolean
		{
			return ( bitmap ) ? true : false;
		}
		
		private function loadBackground():void
		{
			loaderContext = new LoaderContext( true );
			bgLoader = new Loader();				
			bgLoader.name = "bgLoader";
			bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			bgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			bgLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			bgLoader.addEventListener( IOErrorEvent.NETWORK_ERROR, onErrorHandler, false, 0, true );
			bgLoader.load( new URLRequest( DEFAULT_BG_IMAGE ), loaderContext );
			ShowHideManager.addContent( (this as Background), bgLoader );
		}
		
		private function showBitmap( e:Event ):void
		{
			var assetLoader:Loader = e.currentTarget.loader as Loader;
				assetLoader.alpha = 0;
			var asset:LoaderInfo = e.currentTarget as LoaderInfo;
			//Assign the background image
			bitmap = asset.content as Bitmap;
			defaultWidth = bitmap.width;
			defaultHeight = bitmap.height;
			//Create an Aspect Ratio for the Background IMage
			aspectRatio = defaultWidth / defaultHeight;
			//Resize the Bitmap to fit either the browser or Theatre Mode (Full Screen)
			resizeBitmap();
			//Tween in the image
			TweenLite.to( assetLoader, 1, { alpha: 1 } ); 			
		}
		
		//Resize Bitmap handles fullScreen and normalScreen so that you only need to update from one place
		private function resizeBitmap( ):void
		{
			//Adjust the image to the browser window
			if( stage.displayState == "fullScreen" ){
				adjustSize( stage.stageWidth, (stage.stageHeight / aspectRatio) );				
			} else {
				//Adjust the Background to match the size of the browser
				if( browserWidth && browserHeight ) adjustSize( browserWidth, browserHeight );
				//SWF is being loaded from IDE
				else adjustSize( defaultWidth, defaultHeight );
			}			
		}

		//Not in use
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
			//The Bitmap Image is loaded
			if( bitmapIsLoaded() ){
				//Browser window is larger than the default Bitmap image
				if( w > MIN_WIDTH ){
					width = w;
					height = w / aspectRatio;
				} 
				//The Browswer window is smaller than the minimum width
				else {
					width = MIN_WIDTH;
					height = MIN_WIDTH / aspectRatio;
				}
			}
		}
		
		/**********************************
		 * Event
		 **********************************/	
		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//Keep track of the Browser Window
			browserWidth = e.windowWidth;
			browserHeight = e.windowHeight;
			
			//trace( "Background::swfSizerHandler:", e.type, e.windowWidth, e.windowHeight );
			resizeBitmap();
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			showBitmap( e );
		}
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "Background::onErrorHandler:", e.text );
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
			trace( "Background::onFullScreenHandler:", e.fullScreen, stage.stageWidth, stage.stageHeight );			
			resizeBitmap();
		}
				
		private function addedToStageHandler( e:Event ):void
		{
			//trace( "HeaderView::addedToStageHandler:" );
			init();
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			trace( "Background::removedFromStageHandler:" );
		}
		
	}
}