package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.SwfLoad;
	import org.tizianoproject.view.CompositeView;
	
	public class Quiz extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 34, 110 );
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 375;
		
		private var swfLoader:SwfLoad;
		private var container:Sprite;
		
		public function Quiz()
		{
			x = DEFAULT_POS.x;
			y = DEFAULT_POS.y;
		}
		
		public function load( path:String ):void
		{
			swfLoader = new SwfLoad( new URLRequest( path ), new LoaderContext(true) );
			swfLoader.addEventListener( LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoader.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			swfLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			swfLoader.start();
		}
		
		private function showQuiz( loader:Loader ):void
		{
			trace( "Quiz::showQuiz:" );
			ShowHideManager.addContent( (this as Quiz), loader );
		}

		override protected function unload():void
		{
			trace( "Quiz::unload:" );	

			unloadSwfLoader();
			//Obsessively destroy everything!
			ShowHideManager.unloadContent( (this as Quiz) ) 
		}

		private function unloadSwfLoader():void
		{
			if( swfLoader ) { 
				swfLoader.stop(); 
				swfLoader.destroy(); 
				swfLoader = null; 
			}			
		}

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onCompleteHandler( e:Event ):void
		{
			//Assign the loader which will display the SoundSlide
			showQuiz( (swfLoader.loader as Loader) );
			//Destroy the swfLoader once the SoundSlide has been loaded
			unloadSwfLoader();
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "SoundSlide::onErrorHandler:" );
		}		

	}
}