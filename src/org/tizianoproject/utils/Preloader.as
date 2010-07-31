package org.tizianoproject.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	
	import org.casalib.util.StageReference;
	
	public class Preloader extends MovieClip
	{		
		private var swfLoader:Loader;
		private var swfURL:String = "http://demo.chrisaiv.com/swf/tiziano/main.swf";

		public function Preloader()
		{
			swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler, false, 0, true );
			swfLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler, false, 0, true );			
			swfLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
			swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );
				
			try{
				swfLoader.load( new URLRequest( swfURL ), new LoaderContext( true ) );
			} catch( e:Error ){ trace( "Error!!!!") } 
		}

		/**********************************
		 * Flash Vars
		 **********************************/
		private function isProductionMode():Boolean
		{
			var runtimeEvironment:String = Capabilities.playerType;
			
			if (runtimeEvironment == "External" || runtimeEvironment == "StandAlone"){
				return false;
			} else {
				return true;
			}
		}

		private function getFlashVars():Object {
			return Object(LoaderInfo(this.loaderInfo).parameters);
		}

		/**********************************
		 * Events
		 **********************************/
		private function securityErrorHandler( e:SecurityErrorEvent ):void
		{
			trace("securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace( "ioErrorHandler: " + e );
		}		
		
		private function onHttpStatusHandler( e:HTTPStatusEvent ):void
		{
			trace( "onHttpStatusHandler:" );
		}
		
		private function onProgressHandler( e:ProgressEvent ):void {
			trace( Math.round( e.bytesLoaded / e.bytesTotal * 100 ).toString() + " %" );
		}
		
		private function onCompleteHandler( e:Event ):void {
			//Remove this Preloader
			removeChildAt( 0 );		
			
			//Kick off the Main class
			addChild( e.currentTarget.loader );
		}

	}
}