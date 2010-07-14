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
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.profiler.showRedrawRegions;
	import flash.system.Security;
	import flash.utils.Timer;
	
	public class VimeoPlayer extends Sprite {

		//The Video Player
		private var moogaPlayer:Object; 

		private var vimeoContainer:Sprite;
		private var vimeoLoader:Loader;
		private var vimeoWidth:Number;
		private var vimeoHeight:Number;
		private var vimeoMask:Sprite;

		private var timer:Timer;
		
		public function VimeoPlayer(oauth_key:String, clip_id:int, w:int, h:int) {

			Security.allowDomain("*");
			Security.loadPolicyFile("http://vimeo.com/moogaloop/crossdomain.xml");

			this.setDimensions(w, h);
			
			var urlVars:URLVariables = new URLVariables();
				urlVars.cache_clear = new Date().getTime();
				urlVars.oauth_key = oauth_key;
				urlVars.clip_id = clip_id;
				urlVars.width = w;
				urlVars.height = h;
				urlVars.portrait = false;
				urlVars.hd_off = 1;
				urlVars.fullscreen = false;				

			var request:URLRequest = new URLRequest();
				request.url = "http://api.vimeo.com/moogaloop_api.swf";
				request.data = urlVars;
				request.method = URLRequestMethod.GET;

			vimeoLoader = new Loader();
			vimeoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true );
			vimeoLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( IOErrorEvent.NETWORK_ERROR, onIOErrorHandler, false, 0, true );
			vimeoLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityHandler, false, 0, true );
			vimeoLoader.load( request );			
		}
		
		/**********************************
		 * Public Methods
		 **********************************/
		public function load( id:uint ):void
		{
			trace( "VimeoPlayer::loadVideo:" );

			moogaPlayer.api_loadVideo(id);
			
			timer.addEventListener(TimerEvent.TIMER, onTimerHandler, false, 0, true );
		}
		
		//Kill the video and unload it
		public function close():void
		{
			moogaPlayer.api_unload();
		}
		
		public function play():void
		{
			moogaPlayer.api_play();
		}
		
		public function pause():void
		{
			moogaPlayer.api_pause();
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
		
		private function unload():void
		{
			trace( "VimeoPlayer::unload:" );
		}

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onCompleteHandler( e:Event ):void
		{
			trace( "VimeoPlayer::onCompleteHandler:" );
			vimeoMask = new Sprite();
			vimeoMask.name = "vimeoMask";
			
			//Allow your moogaplayer to be positioned anywhere
			vimeoContainer = new Sprite();
			vimeoContainer.mask = vimeoMask;
			vimeoContainer.name = "vimeoContainer";
			vimeoContainer.addChild( e.target.loader.content );
			//Assign the player
			moogaPlayer = e.target.loader.content;
			//Create a Mask to fix some artifact issues
			
			//Add to Stage			
			ShowHideManager.addContent( (this as VimeoPlayer), vimeoMask );
			ShowHideManager.addContent( (this as VimeoPlayer), vimeoContainer );
			//Redraw the mask
			redrawMask();
			
			//Keep track of when the video is properly loaded
			timer = new Timer( 200 );
			timer.addEventListener(TimerEvent.TIMER, onTimerHandler, false, 0, true );
		}
		
		private function onTimerHandler( e:TimerEvent ):void
		{
			trace( "VimeoPlayer::onTimerHandler:" );
			playerLoadedCheck();
		}
		
		//Wait for Moogaloop to finish setting up
		private function playerLoadedCheck():void
		{
			trace( "VimeoPlayer::playerLoadedCheck:", moogaPlayer.player_loaded );
			if( moogaPlayer.player_loaded ){
				
				if( timer ){
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimerHandler );
				}
				
				if( moogaPlayer ){
					moogaPlayer.disableMouseMove();					
				}
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
				dispatchEvent(new Event(Event.COMPLETE));				
			}
		}
		
		//Fake the mouse move/out events for Moogaloop
		private function mouseMove(e:MouseEvent):void 
		{
			if ( e.stageX >= this.x && e.stageX <= this.x + vimeoWidth &&
				e.stageY >= this.y && e.stageY <= this.y + vimeoHeight ) {
				moogaPlayer.mouseMove( e );
			} else {
				moogaPlayer.mouseOut();
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
			unload();
			trace( "VimeoPlayer::onErrorHandler:" );
		}
	}
}