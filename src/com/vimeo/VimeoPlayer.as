/**
 * VimeoPlayer
 * 
 * !!! Read this!!!!!
 * http://blog.robertabramski.com/2009/05/25/vimeo-player-and-the-secret-api/
 * 
 * A wrapper class for Vimeo's video player (codenamed Moogaloop)
 * that allows you to embed easily into any AS3 application.
 * 
 * Example on how to use:
 * 	var vimeo_player = new VimeoPlayer([YOUR_APPLICATIONS_CONSUMER_KEY], 2, 400, 300);
 * 	vimeo_player.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);	
 * 	addChild(vimeo_player);
 * 
 * http://vimeo.com/api/docs/moogaloop
 *
 * Register your application for access to the Moogaloop API at:
 * http://vimeo.com/api/applications
 * 
 * Param Options
 * http://vimeo.com/api/docs/moogaloop
 */
package com.vimeo{
	
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.profiler.showRedrawRegions;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.SwfLoad;
	import org.casalib.util.ArrayUtil;
	import org.casalib.util.ObjectUtil;
	
	public class VimeoPlayer extends Sprite {

		//The Video Player
		private var moogaPlayer:Object; 

		private var vimeoContainer:Sprite;
		private var vimeoLoader:Loader;
		private var vimeoWidth:Number;
		private var vimeoHeight:Number;
		private var vimeoMask:Sprite;

		private var timer:Timer;
		private var swfLoad:SwfLoad;
		private var loaderContext:LoaderContext;
		
		public function VimeoPlayer(oauth_key:String, clip_id:int, w:int, h:int) {
			
			trace( "NEW NEW NEW VIMEO " );
			Security.allowDomain("*");
			Security.loadPolicyFile("http://vimeo.com/moogaloop/crossdomain.xml");
			loaderContext = new LoaderContext( true );

			this.setDimensions(w, h);
			
			var urlVars:URLVariables = new URLVariables();
				urlVars.cache_clear = new Date().getTime();
				urlVars.oauth_key = oauth_key;
				var videos:Array = new Array("13782816", "3369107");
				urlVars.clip_id = ArrayUtil.randomize(videos)[0];
				urlVars.width = w;
				urlVars.height = h;
				//urlVars.portrait = false;
				//urlVars.hd_off = 1;
				//urlVars.fp = 10;
				//urlVars.fullscreen = false;				
				//urlVars.fullscreen = 0;				

			var request:URLRequest = new URLRequest();
				request.url = "http://api.vimeo.com/moogaloop_api.swf";
				request.data = urlVars;
				request.method = URLRequestMethod.GET;

				/*
			vimeoLoader = new Loader();
			vimeoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadCompleteHandler, false, 0, true );
			vimeoLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( IOErrorEvent.NETWORK_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true );
			try{
				vimeoLoader.load( request );				
			} catch( e:Error ){ trace( "VimeoPlayer::constructor:Error:", e.message ) }
				*/
				swfLoad = new SwfLoad( request, loaderContext );
				swfLoad.addEventListener(LoadEvent.COMPLETE, onLoadCompleteHandler, false, 0, true );
				swfLoad.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
				swfLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true );
				swfLoad.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		/**********************************
		 * Public Methods
		 **********************************/
		public function load( id:uint ):void
		{
			trace( "VimeoPlayer::loadVideo:", id );
			if( moogaPlayer ) {
				try{
					moogaPlayer.api_loadVideo( id );					
				} catch( e:Error ){ trace( "VimeoPlayer::load:Error:", e.message ) }
				
				//Keep Track of when the player has properly loaded
				timerStart();				
			}
		}
		
		//Kill the video and unload it
		public function close():void
		{
			//if( moogaPlayer ) moogaPlayer.api_unload();
			if( moogaPlayer ) moogaPlayer.api_pause();
		}
		
		public function play():void
		{
			if( moogaPlayer ) moogaPlayer.api_play();
		}
		
		public function pause():void
		{
			if( moogaPlayer ) moogaPlayer.api_pause();
		}
		
		public function stop():void
		{
			close();
		}
		
		//returns duration of video in seconds
		public function getDuration():int
		{
			return moogaPlayer.api_getDuration();			
		}
		
		//Seek to specific loaded time in video (in seconds)
		public function seekTo( time:int ):void
		{
			moogaPlayer.api_seekTo( time );	
		}
		
		//Change the primary color (i.e. 00ADEF)
		public function changeColor( hex:String ):void 
		{
			moogaPlayer.api_changeColor( hex );
		}

		
		/**********************************
		 * 
		 **********************************/
		private function setDimensions( w:int, h:int ):void 
		{
			vimeoWidth  = w;
			vimeoHeight = h;
		}
		
		//Set the Video Size
		private function setSize( w:int, h:int ):void
		{
			setDimensions( w, h );
			if( moogaPlayer.player_loaded ){
				moogaPlayer.api_setSize( w, h );
				redrawMask();				
			}
		}

		private function redrawMask():void
		{
			with ( vimeoMask.graphics ) {
				beginFill( 0xffcc00, 1 );
				drawRect( vimeoContainer.x, vimeoContainer.y, vimeoWidth, vimeoHeight );
				endFill();
			}
		}
		
		//We don't really unload it, we simply close the video connection but keep the player
		private function unload():void
		{
			trace( "VimeoPlayer::unload:" );
			if( moogaPlayer ){
				if( moogaPlayer.api_isPlaying ){
					stop();
				}	
			}
		}

		/**********************************
		 * Timer
		 **********************************/
		private function timerStart():void
		{
			timer = new Timer( 50 );
			timer.addEventListener(TimerEvent.TIMER, onTimerHandler, false, 0, true );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler, false, 0, true );
			timer.start();
		}
		
		private function timerReset():void
		{
			timer.reset();
		}
		
		private function timerStop():void
		{
			timer.removeEventListener(TimerEvent.TIMER, onTimerHandler );			
			timer.stop();
		}		

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onLoadCompleteHandler( e:LoadEvent ):void
		{
			//trace( "VimeoPlayer::onLoadCompleteHandler:" );
			
			//Assign the player
			moogaPlayer = swfLoad.content; //e.target.loader.content;
			moogaPlayer.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
			moogaPlayer.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true );
			moogaPlayer.addEventListener( ErrorEvent.ERROR, onErrorHandler, false, 0, true );
			initMoogaHolder();
		}
		
		private function initMoogaHolder():void
		{
			//Create a Mask to fix some artifact issues
			vimeoMask = new Sprite();
			vimeoMask.name = "vimeoMask";
			
			//Allow your moogaplayer to be positioned anywhere
			vimeoContainer = new Sprite();
			//			vimeoContainer.mask = vimeoMask;
			vimeoContainer.name = "vimeoContainer";
			vimeoContainer.addChild( (moogaPlayer as DisplayObject) );
			
			//			ShowHideManager.addContent( (this as VimeoPlayer), vimeoMask );
			ShowHideManager.addContent( (this as VimeoPlayer), vimeoContainer );
			//Redraw the mask
			//			redrawMask();
			
			//Keep track of when the video is properly loaded
			timerStart();			
		}
		
		private function onTimerHandler( e:TimerEvent ):void
		{
			//trace( "VimeoPlayer::onTimerHandler:" );
			playerLoadedCheck();
		}
		
		private function onTimerCompleteHandler( e:TimerEvent ):void
		{
			trace( "VideoPlayer::onTimerCompleteHandler:" );
		}
		
		//Wait for Moogaloop to finish setting up
		private function playerLoadedCheck():void
		{
			trace( "VimeoPlayer::playerLoadedCheck:", moogaPlayer,  new Date().getTime() );
			if( !ObjectUtil.isNull(moogaPlayer) ){
				trace( "1"  );
				if( moogaPlayer.player_loaded ){
					trace( "2" );
					if( timer ) timerStop();
					try{
						trace( "3" );
						moogaPlayer.disableMouseMove();	
					} catch( e:Error ){ trace( "VimeoPlayer:playerLoadedCheck: Error", e.message ) }
										
					trace( "4" );
					if( stage ) stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					
					dispatchEvent(new Event(Event.COMPLETE));				
				}				
			}
		}

		//Fake the mouse move/out events for Moogaloop
		private function mouseMove(e:MouseEvent):void 
		{
			trace( "VimeoPlayer::mouseMove:", e.localX, e.localY );
			if( !ObjectUtil.isNull(moogaPlayer) ){
				if ( e.stageX >= this.x && e.stageX <= this.x + vimeoWidth &&
					e.stageY >= this.y && e.stageY <= this.y + vimeoHeight ) {
					moogaPlayer.mouseMove( e );
				} else {
					moogaPlayer.mouseOut();
				}				
			}
		}
		
		private function onIOErrorHandler( e:IOErrorEvent ):void
		{
			trace( "VimeoPlayer::onIOErrorHandler:", e.text );
		}
		
		private function onSecurityHandler( e:SecurityErrorEvent ):void
		{
			trace( "VimeoPlayer::onSecurityHandler:", e.text );
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "VimeoPlayer::onErrorHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();	
		}
	}
}