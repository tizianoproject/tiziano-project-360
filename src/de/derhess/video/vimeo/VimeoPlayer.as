package de.derhess.video.vimeo {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.Timer;
	
	/**
	 * released under MIT License (X11)
	 * http://www.opensource.org/licenses/mit-license.php
	 * 
	 * A wrapper class for Vimeo's video player (codenamed Moogaloop)
	 * that allows you to embed easily into any AS3 application.
     * 
	 * Documentation:
	 * 
	 * http://blog.derhess.de
	 * http://vimeo.com/api/docs/moogaloop
	 *
	 * Modified and extended by Florian Weil
	 * @author Florian Weil [derhess.de, Deutschland]
	 * @see http://blog.derhess.de
	 */
	
	public class VimeoPlayer extends Sprite {
		
		//--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
		public static var MAX_REPEAT_SAME_CURRENT_TIME:int = 3;
		
		//--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
		public function VimeoPlayer( oauth_key:String, clip_id:int, w:int, h:int) {
			this.setDimensions(w, h);
			
			Security.allowDomain("*");

			var urlVars:URLVariables = new URLVariables();
				urlVars.cache_clear = new Date().getTime();
				urlVars.oauth_key = oauth_key;
				urlVars.width = w;
				urlVars.height = h;
				urlVars.clip_id = clip_id;
				urlVars.hd_off = 1;
				urlVars.fp = 10;
			
			var request:URLRequest = new URLRequest();
			request.url = "http://api.vimeo.com/moogaloop_api.swf";
//			request.url = "http://bitcast.vimeo.com/vimeo/swf/moogaloop.swf";
			request.data = urlVars;
			request.method = URLRequestMethod.GET;
			
			var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete,false,0,true);
				loader.load(request); 
		}
		//--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
		private var container:Sprite = new Sprite(); // sprite that holds the player
		private var moogaloop:Object = false; // the player
		private var player_mask:Sprite = new Sprite(); // some sprites inside moogaloop go outside the bounds of the player. we use a mask to hide it
		
		private var load_timer:Timer = new Timer(200);
		private var event_timer:Timer = new Timer(100);
		
		private var playerColor:String ="";
		private var volume:Number = 100;
		private var duration:Number = 0;
		private var isDurationChanged:Boolean = true;
		
		private var oldCurrentTime:Number = 0;
		private var completeCurrentTimeCounter:int = 0;
		
		//--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
		public var player_width:int = 400; // To Change the player size use the setSize(w,h) function
		public var player_height:int = 300; // To Change the player size use the setSize(w,h) function
		public var enableCompleteEvent:Boolean = true; // when set this to false, the wrapper class will stop dispatching Events - (Perfomance)
		public var enablePlayheadEvent:Boolean = true; // when set this to false, the wrapper class will stop dispatching Playing Status Events (Perfomance))
		
		//--------------------------------------------------------------------------
        //
        //  Additional getters and setters
        //
        //--------------------------------------------------------------------------
		/**
		 * return if the video is playing or not
		 * @return
		 */
		public function isVideoPlaying():Boolean
		{
			return moogaloop.api_isPlaying();
		}
		
		/**
		 * Returns the current video playhead time in milli seconds
		 * @return
		 */
		public function getCurrentVideoTime():Number
		{
			return moogaloop.api_getCurrentTime();
		}
		
		/**
		 * returns duration of video in seconds
		 */
		public function getDuration():Number
		{	
			if (moogaloop.player_loaded )
			{
				var tDuration:Number = moogaloop.api_getDuration();
			
				if (isDurationChanged && (tDuration != duration))
				{
					isDurationChanged = false;
					duration = tDuration
					var e:VimeoEvent = new VimeoEvent(VimeoEvent.DURATION);
					e.duration = duration
					dispatchEvent(e);
					
				}
				return duration;
			}
				else
			{
				return 0;
			}
		}

		public function getPlayerColor():String
		{
			return playerColor;
		}
		
		/**
		 * set Volume for the video. Values between 0-100
		 */
		public function setVolume(value:Number):void
		{
			moogaloop.api_setVolume(value);
			volume = value;
		}
		
		public function getVolume():Number
		{
			return volume;
		}
		
		
		//--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
		public function stop():void
		{
			if (getCurrentVideoTime() > 0)
			{
				seekTo(0);
				pause();
				event_timer.stop();
				event_timer.reset();
				
				var e:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
					e.duration = duration;
					e.info = VimeoPlayingState.STOP;
					dispatchEvent(e);
			}
		}
		
		public function play():void {
			moogaloop.api_play();
			getDuration();

			if (enableCompleteEvent)
			{
				event_timer.start();				
			}
				else
			{
				var e:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				e.currentTime = getCurrentVideoTime();
				e.duration = 0;
				e.info = VimeoPlayingState.PLAYING;
				dispatchEvent(e);
			}
		}
		
		public function pause():void {
			moogaloop.api_pause();
			var e:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
			e.currentTime = getCurrentVideoTime();
			e.duration = 0;
			e.info = VimeoPlayingState.PAUSE;
			dispatchEvent(e);
			event_timer.stop();
			event_timer.reset();
		}
		
		/**
		 * Seek to specific loaded time in video (in seconds)
		 */
		public function seekTo(time:int):void {
			moogaloop.api_seekTo(time);
			
			if (enablePlayheadEvent)
			{
				var vimeoPlayEvent:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				vimeoPlayEvent.currentTime = time;
				vimeoPlayEvent.duration = duration;
				vimeoPlayEvent.info = VimeoPlayingState.PLAYING;
				dispatchEvent(vimeoPlayEvent);
			}
		}
		
		public function unloadVideo():void
		{
			moogaloop.api_unload();
			var e:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				e.duration = 0;
				e.info = VimeoPlayingState.UNLOAD;
				dispatchEvent(e);
				
			event_timer.stop();
			event_timer.reset();
		}
		
		/**
		 * Load in a different video
		 */
		public function loadVideo(id:int):void {
			trace( "VideoPlayer::loadVideo:", id );
			moogaloop.api_loadVideo(id);
			isDurationChanged = true;
			
			// reset duration property
			duration = 0;
			var e:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				e.duration = 0;
				e.info = VimeoPlayingState.NEW_VIDEO;
			dispatchEvent(e);
			event_timer.stop();
			event_timer.reset();
		}
		
		/**
		 * Change the size of the VideoPlayer
		 * @param	w width
		 * @param	h height
		 */
		public function setSize(w:int, h:int):void {
			this.setDimensions(w, h);
			moogaloop.api_setSize(w, h);
			this.redrawMask();
		}
		
		
		/**
		 * Toggle loop for the video
		 * 
		 */
		public function toggleLoop():void
		{
			moogaloop.api_toggleLoop();
		}
		
		
		/////////////////////////////////////
		// Video & Vimeo Control Display
		/**
		 * This Function throws an error, because the embed player is not able to handle fullscreen mode, use instead setSize(w,h)
		 */
		/*public function toggleFullscreen():void
		{
			moogaloop.api_toggleFullscreen();
		}*/
		
		
		
		/**
		 * enable HD for the player, but it seems that it is not working?!
		 */
		public function hd_on():void
		{
			moogaloop.api_enableHDEmbed();
		}
		
		
		/**
		 * I think this function will be changed in the future ---> it seems that is not working?!
		 */
		public function hd_off():void
		{
			moogaloop.api_disableHDEmbed();
		}
		
		/**
		 * Change the primary color (i.e. 00ADEF) of the player vimeo gui controls
		 */
		public function changeColor(hex:String):void {
			moogaloop.api_changeColor(hex);
			playerColor = hex;
		}
		
		//////////////////////////////////////////
		// Screen Management
		public function showLikeScreen():void
		{
			moogaloop.onShowLikeScreen();
		}
		
		public function showEmbedScreen():void
		{
			moogaloop.onShowEmbedScreen();
		}
		
		public function showHDScreen():void
		{
			moogaloop.onShowHDScreen();
		}
		
		public function showShareScreen():void
		{
			moogaloop.onShowShareScreen();
		}
		
		public function showVimeoScreenControlls():void
		{
			moogaloop.onScreenShow( { } );
		}
		
		
		/**
         * Completely destroys the instance and frees all objects for the garbage
         * collector by setting their references to null.
         */
        public function destroy():void
        {
			pause();
						
			if (player_mask && player_mask.stage)
			{	
				removeChild(player_mask);
				player_mask = null;
			}
			
			if (moogaloop && moogaloop.stage)
			{
				moogaloop = null;
			}
			
			if (container && container.stage)
			{
				removeChild(container);
				container = null;
			}
			
			load_timer = null;
			event_timer.removeEventListener(TimerEvent.TIMER, handleEventTimer);
			event_timer = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
        }
		//--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
		private function setDimensions(w:int, h:int):void {
			player_width  = w;
			player_height = h;
		}
		
		private function onComplete(e:Event):void {
			// Finished loading moogaloop
			container.addChild(e.target.loader.content);
			moogaloop = e.target.loader.content;
			
			
			// Create the mask for moogaloop
			addChild(player_mask);
			container.mask = player_mask;
			addChild(container);
			
			redrawMask();
			 
			load_timer.addEventListener(TimerEvent.TIMER, playerLoadedCheck);
			load_timer.start();
		}
		
		/**
		 * Wait for Moogaloop to finish setting up
		 */
		private function playerLoadedCheck(e:TimerEvent):void {
			if( moogaloop.player_loaded ) {
				// Moogaloop is finished configuring
				load_timer.stop();
				load_timer.removeEventListener(TimerEvent.TIMER, playerLoadedCheck);
				event_timer.addEventListener(TimerEvent.TIMER, handleEventTimer);

				// remove moogaloop's mouse listeners listener
				moogaloop.disableMouseMove(); 
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
				//HD Video
				//moogaloop.api_enableHDEmbed();
				
				var vimeoEvent:VimeoEvent = new VimeoEvent(VimeoEvent.PLAYER_LOADED);
				vimeoEvent.duration = 0;
				vimeoEvent.info = "player_loaded";
				dispatchEvent(vimeoEvent);
			}
		}
		
		/**
		 * dispatch Event for the VideoStatus
		 * @param	e
		 */
		private function handleEventTimer(e:TimerEvent):void
		{
			
			var isPlaying:Boolean = true;
			var newCurrentTime:Number = getCurrentVideoTime();
			//Check if the currentTime Value already exists
			if (oldCurrentTime == newCurrentTime && oldCurrentTime != 0)
			{
				completeCurrentTimeCounter++;
			}
				else if(newCurrentTime == 0)
			{
				var vimeoEvent:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				vimeoEvent.currentTime = newCurrentTime;
				vimeoEvent.duration = getDuration();
				vimeoEvent.info = VimeoPlayingState.BUFFERING;
				dispatchEvent(vimeoEvent);
				isPlaying = false;
			}
			
			// It is almost impossible that the currentTime has the same value MAX_REPEAT_SAME_CURRENT_TIME times,
			// when it is playing. So I think the video playing is completed
			if (!isVideoPlaying() && (completeCurrentTimeCounter >= MAX_REPEAT_SAME_CURRENT_TIME) )
			{
				var vimeoEventComplete:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				vimeoEventComplete.currentTime = getDuration();
				vimeoEventComplete.duration = getDuration();
				vimeoEventComplete.info = VimeoPlayingState.VIDEO_COMPLETE;
				dispatchEvent(vimeoEventComplete);
				event_timer.stop();
				event_timer.reset();
				isPlaying = false;
				oldCurrentTime = 0;
				completeCurrentTimeCounter = 0;
			}
				else
			{
				oldCurrentTime = newCurrentTime;
			}
			
			
			// Dispatch Video when Playing
			if (enablePlayheadEvent && isPlaying)
			{
				var vimeoPlayEvent:VimeoEvent = new VimeoEvent(VimeoEvent.STATUS);
				vimeoPlayEvent.currentTime = getCurrentVideoTime();
				vimeoPlayEvent.duration = getDuration();
				vimeoPlayEvent.info = VimeoPlayingState.PLAYING;
				dispatchEvent(vimeoPlayEvent);
			}
			
		}
		
		/**
		 * Fake the mouse move/out events for Moogaloop
		 */
		private function mouseMove(e:MouseEvent):void {
			if( this.mouseX >= this.x && this.mouseX <= this.x + this.player_width &&
				this.mouseY >= this.y && this.mouseY <= this.y + this.player_height ) {
				moogaloop.mouseMove(e);
			}
			else {
				moogaloop.mouseOut();
			}
		}
		
		private function redrawMask():void {
			with( player_mask.graphics ) {
				beginFill(0x000000, 1);
				drawRect(container.x, container.y, player_width, player_height);
				endFill();
			}
		}
		
		
	}
}