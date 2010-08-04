package de.derhess.video.vimeo
{
    /**
     * Description
     * Class stores the PlayingStates of the VideoPlayer
     * 
     * @author Florian Weil [derhess.de, Switzerland]
     */
     
	 
    public class VimeoPlayingState
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        public static const PLAYING:String = "vimeoPlaying"; // will be dispatched when the video is playing
		public static const PAUSE:String = "vimeoPause"; // will be dispatched when the video is paused
		public static const STOP:String = "vimeoStop"; // will be dispatched when the video is stopped
		public static const NEW_VIDEO:String = "vimeoNewVideo"; // will be dispatched when a new clip is loaded
		public static const UNLOAD:String = "vimeoUnload"; // will be dispatched when the video is unloaded and removed from the cach
		public static const VIDEO_COMPLETE:String = "vimeoVideoComplete"; // will be dispatched when the playhead reach the end of the video
		public static const BUFFERING:String = "vimeoVideoBuffering"; // will be dispatched when the playhead reach the end of the video
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        
        public function VimeoPlayingState()
        {
			throw new Error("VimeoPlayingState is a static class. Creating instances are not allowed!");
        }
        
        
        
        
    }
}