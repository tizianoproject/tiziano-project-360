package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class SoundSlide extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 34;
		private static const DEFAULT_Y_POS:Number = 110;

		private var loaderContext:LoaderContext;
		private var ssLoader:Loader;
		
		public function SoundSlide()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function init():void
		{			
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;			
		}
		
		public function load( path:String ):void
		{
			loaderContext = new LoaderContext( true );
			ssLoader = new Loader();				
			ssLoader.name = "ssLoader";
			ssLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			ssLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			ssLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			ssLoader.load( new URLRequest( path ), loaderContext );
			ShowHideManager.addContent( (this as SoundSlide), ssLoader );			
		}
		
		private function unload():void
		{
			//trace( "SoundSlide::unload:", ssLoader.content );	
			//Stop any possible sounds
			SoundMixer.stopAll();
			//Unload the Loader
			ssLoader.unload();
			ShowHideManager.removeContent( (this as SoundSlide), "ssLoader" );
			ssLoader = null;
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onCompleteHandler( e:Event ):void
		{
			trace( "SoundSlide::onCompleteHandler:" );
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "SoundSlide::onErrorHandler:" );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
			trace( "SlideShow::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
			trace( "SlideShow::onRemovedFromStageHandler:" );
		}		
		
	}
}