package org.tizianoproject.utils
{
	import com.chrisaiv.utils.ShowHideManager;
	
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
	import flash.system.Security;
	import flash.text.TextField;
	
	import org.casalib.util.StageReference;
	
	public class Preloader extends MovieClip
	{		
		private static const MAIN_APPLICATION:String = "http://360.tizianoproject.org/swf/main.swf";
		
		private var swfLoader:Loader;

		public function Preloader()
		{
			Security.allowDomain("*");
			
			swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler, false, 0, true );
			swfLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true );
			swfLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler, false, 0, true );			
			swfLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
			swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );
				
			try{
				swfLoader.load( new URLRequest( MAIN_APPLICATION ), new LoaderContext( true ) );
			} catch( e:Error ){ trace( "Preloader::Error!!!!") } 
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
			percent_txt.text = ( Math.floor( e.bytesLoaded / e.bytesTotal * 100 ).toString() + " %" );
		}
		
		private function onCompleteHandler( e:Event ):void 
		{
			//Remove the TextField but keep the Stage
			ShowHideManager.unloadContent( (this as Preloader), 1 );
			//Remove this Preloader
			removeChildAt( 0 );		
			
			//Kick off the Main class
			addChild( e.currentTarget.loader );
		}

	}
}