package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class SoundSlide extends MovieClip
	{
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
			trace( "SlideShow::onRemovedFromStageHandler:" );
		}		
		
	}
}