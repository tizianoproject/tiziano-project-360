/** -----------------------------------------------------------
 * Vimeo Video Player
 * -----------------------------------------------------------
 * Description: 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 *
 */
package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	import com.vimeo.VimeoPlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.utils.describeType;
	
	public class Video extends MovieClip
	{
		private static const VIMEO_CONSUMER_KEY:String = "dba8f8dd0a80ed66b982ef862f75383d";

		private static const DEFAULT_VIDEO_ID:Number = 12618396;
		private static const DEFAULT_X_POS:Number = 35;
		private static const DEFAULT_Y_POS:Number = 105;
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 256;
		
		private var _consumerKey:String;
		
		private var vimeoPlayer:VimeoPlayer;
		
		public function Video( )
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function init():void
		{
		}
		
		public function load( id:Number ):void
		{
			//Unload any previous videos
			unload();
			//Load new video
			vimeoPlayer = new VimeoPlayer( consumerKey, id, DEFAULT_WIDTH, DEFAULT_HEIGHT );
			vimeoPlayer.name = "vimeoPlayer";
			vimeoPlayer.x = DEFAULT_X_POS;
			vimeoPlayer.y = DEFAULT_Y_POS;
			vimeoPlayer.addEventListener( Event.COMPLETE, videoLoadedHandler, false, 0, true );
			ShowHideManager.addContent( (this as Video), vimeoPlayer );
		}
		
		public function loadNewVideo( id:Number ):void
		{
			vimeoPlayer.loadVideo( id );
		}
		
		private function unload():void
		{			
			if( vimeoPlayer ){
				vimeoPlayer.close();
				vimeoPlayer = null;
			}
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function videoLoadedHandler( e:Event ):void
		{
			trace( "videoLoadedHandler:" );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
			//trace( "Video::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
			trace( "Video::onRemovedFromStageHandler:" );
		}
		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function set consumerKey( value:String ):void
		{
			_consumerKey = value;
		}
		
		public function get consumerKey():String
		{
			return _consumerKey;
		}
	}
}