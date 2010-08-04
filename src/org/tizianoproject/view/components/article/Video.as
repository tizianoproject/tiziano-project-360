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
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.utils.describeType;
	
	import org.tizianoproject.view.CompositeView;
	
	public class Video extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 35, 105 );
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 256;
		
		private var _consumerKey:String;
		
		private var vimeoPlayer:VimeoPlayer;
		
		public function Video( )
		{
		}
		
		public function load( id:Number ):void
		{
			//A video player already exists
			if( vimeoPlayer ) vimeoPlayer.load( id );
			else initPlayer( id );
		}
		
		private function initPlayer( id:Number ):void
		{
			//Load new video
			vimeoPlayer = new VimeoPlayer( consumerKey, id, DEFAULT_WIDTH, DEFAULT_HEIGHT );
			vimeoPlayer.name = "vimeoPlayer";
			vimeoPlayer.x = DEFAULT_POS.x;
			vimeoPlayer.y = DEFAULT_POS.y;
			vimeoPlayer.addEventListener( Event.COMPLETE, videoLoadedHandler, false, 0, true );
			ShowHideManager.addContent( (this as Video), vimeoPlayer );
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function videoLoadedHandler( e:Event ):void
		{
			trace( "Video:: VIDEO IS LOADED:" );
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