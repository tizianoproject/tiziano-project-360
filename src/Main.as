package 
{
	import com.chrisaiv.utils.ShowHideManager;
	import com.gskinner.utils.SWFBridgeAS3;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.tizianoproject.view.components.FullScreen;
	import org.tizianoproject.view.components.Overlay;
	
	public class Main extends Sprite
	{
		private static const SWF_PATH:String = "http://demo.chrisaiv.com/swf/tiziano/wall.swf";

		private static const SWF_BRIDGE:String = "swfBridge";
		private static const SWF_BRIDGE_ON_SCREEN_RESIZE:String = "onScreenResize";
		private static const SWF_BRIDGE_CONNECT:String = "sbTest";
		//private static const SWF_PATH:String = "wall.swf";
		
		private var context:LoaderContext;
		private var loader:Loader;
		private var swfBridge:SWFBridgeAS3;
		
		//Views
		public var wall_mc:MovieClip;
		public var header_mc:MovieClip;
		public var footer_mc:MovieClip;
		
		private var appStage:Stage;
		private var overlay:Overlay

		public function Main()
		{		
			appStage = stage;
			appStage.align = StageAlign.TOP_LEFT;
			appStage.scaleMode = StageScaleMode.NO_SCALE;
			appStage.addEventListener( Event.RESIZE, onStageResizeHandler, false, 0, true );
			
			swfBridge = new SWFBridgeAS3( SWF_BRIDGE, this )
			swfBridge.addEventListener( Event.CONNECT, onConnectHandler );			

			context = new LoaderContext( true );
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e){ trace( "Event.COMPLETE"); }, false, 0, true ); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e){trace("IOErrorEvent.IO_ERROR") }, false, 0, true ); 
			loader.load( new URLRequest( SWF_PATH ), context );
			wall_mc.addChild(loader);
		}

		public function onConnectHandler( e:Event ):void
		{
			swfMessage( "connect" );
		}
		
		public function swfMessage( message:String ):void
		{
			switch( message ){
				case "fullScreen":
					swfBridge.send( SWF_BRIDGE_ON_SCREEN_RESIZE, message );					
					break;
				case "normal":
					swfBridge.send( SWF_BRIDGE_ON_SCREEN_RESIZE, message );
					break;
				case "connect":
					swfBridge.send( SWF_BRIDGE_CONNECT, "Sent From:", loaderInfo.url.substr(loaderInfo.url.lastIndexOf("/")) );
					break;
			}
		}
		
		private function onStageResizeHandler( e:Event ):void
		{
			trace( "onStageResizeHandler:", appStage.displayState, (this as Main).x, (this as Main).y );
			
			//Notify the Wall
			swfMessage( appStage.displayState );
			
			if( appStage.displayState == FullScreenEvent.FULL_SCREEN ){
				//Reposition
				(this as Main).x = appStage.stageWidth / 2 - ( (this as Main).width /2 );
				(this as Main).y = appStage.stageHeight / 2 - ( (this as Main).height /2 );				
			} else {
				//Reposition
				(this as Main).x = 0;
				(this as Main).y = 0;
			}
		}
		

		/**********************************
		*
		**********************************/
		public function onPressThumb( param1, param2 ):void
		{
			//trace( "onPressThumb:", param1.description, param2 );
			overlay = new Overlay( 0, 70, appStage.stageWidth, 484 );
			overlay.name = "overlay";
			overlay.addEventListener( Event.CLOSE, onOverlayCloseHandler, false, 0, true );
			ShowHideManager.addContent( appStage, overlay );
		}

		public function onRollOverThumb( param1, param2 ):void
		{
			trace( "onRollOverThumb:", param1.description, param2 );
			footer_mc.title_txt.text = param1.description;
		}

		public function onRollOutThumb( param1, param2 ):void
		{
			trace( "onRollOutThumb:", param1.description, param2 );	
			footer_mc.title_txt.text = "";
		}

		public function sbTest( param1:String, param2:String ):void
		{
			trace( "main::sbTest: ", param1, param2 );
		}		
		
		private function onOverlayCloseHandler( e:Event ):void
		{
			trace( "onOverlayCloseHandler" );
			ShowHideManager.removeContent( appStage, e.currentTarget.name );
		}
	}
}