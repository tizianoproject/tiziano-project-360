package org.tizianoproject.view.components.global
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	public class Preloader extends MovieClip
	{		
		private var swfLoader:Loader;
		private var swfURL:String = "main.swf";

		public function Preloader()
		{
			swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler, false, 0, true );
			swfLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
			swfLoader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );
			
			swfLoader.load( new URLRequest( swfURL ) );
		}

		private function securityErrorHandler( e:SecurityErrorEvent ):void
		{
			trace("securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace( "ioErrorHandler: " + e );
		}		
		
		private function onProgressHandler( e:ProgressEvent ):void {
			trace( Math.round( e.bytesLoaded / e.bytesTotal * 100 ).toString() + " %" );
		}
		
		private function onCompleteHandler( e:Event ):void {
			//Remove this current CHild
			removeChildAt( 0 );
			
			//Add The new Main Class to the Stage
			addChild( e.currentTarget.loader );
		}

	}
}