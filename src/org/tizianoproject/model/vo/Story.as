/**
 * -------------------------------------------------------
 * Story
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 7/18/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * 
 * */

package org.tizianoproject.model.vo
{
	public class Story extends Object
	{
		private var _id:Number;
		private var _authorName:String;
		private var _authorType:String;
		private var _title:String;		
		private var _storyType:String;		
		private var _image:String;
		private var _headline:String;
		private var _subheadline:String;
		private var _caption:String;
		private var _related:Array;
		private var _sound:String;
		private var _bgImage:String;
		
		//Text Article
		private var _content:String;
		//SoundSlide
		private var _path:String;
		//Flickr
		private var _flickrKey:String
		private var _flickrPhotoset:String;
		//Vimeo
		private var _vimeoConsumerKey:String;
		private var _vimeoID:Number;
		
		public function Story()
		{
			
		}
		
		public function set id( value:Number ):void
		{
			_id = value
		}
		
		public function get id():Number
		{
			return _id;	
		}
		
		public function set authorName( value:String ):void
		{
			_authorName = value	
		}
		
		public function get authorName():String
		{
			return _authorName;
		}
		
		public function set authorType( value:String ):void
		{
			_authorType = value	
		}
		
		public function get authorType():String
		{
			return _authorType;
		}
		
		public function set title( value:String ):void
		{
			_title = value;	
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set storyType( value:String ):void
		{
			_storyType = value;
		}
		
		public function get storyType():String
		{
			return _storyType;
		}
		
		public function set image( value:String ):void
		{
			_image = value;	
		}
		
		public function get image():String
		{
			return _image;
		}
		
		public function set headline( value:String ):void
		{
			_headline = value	
		}
		
		public function get headline():String
		{
			return _headline;
		}
		
		public function set subheadline( value:String ):void
		{
			_subheadline = value;	
		}
		
		public function get subheadline():String
		{
			return _subheadline;	
		}
		
		public function set caption( value:String ):void
		{
			_caption = value;	
		}
		
		public function get caption():String
		{
			return _caption;	
		}
		
		public function set sound( value:String ):void
		{
			_sound = value;
		}
		
		public function get sound():String
		{
			return _sound;	
		}
		
		public function set bgImage( value:String ):void
		{
			_bgImage = value;
		}
		
		public function get bgImage():String
		{
			return _bgImage;
		}
		
		//related are the Associations to Stories
		public function set related( value:Array ):void
		{
			_related = value;	
		}
		
		public function get related():Array
		{
			return _related;	
		}
		
		/**
		 * Text Article		
		 **/
		public function set content( value:String ):void
		{
			_content = value;
		}
		
		public function get content( ):String
		{
			return _content;
		}
		
		/**
		 * SoundSlide		
		**/		
		public function set path( value:String ):void
		{
			_path = value;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		/**
		 * Flickr		
		 **/		
		public function set flickrKey( value:String ):void
		{
			_flickrKey = value;
		}
		
		public function get flickrKey():String
		{
			return _flickrKey;
		}
		
		public function set flickrPhotoset( value:String ):void
		{
			_flickrPhotoset = value;	
		}
		
		public function get flickrPhotoset():String
		{
			return _flickrPhotoset;	
		}
		
		/**
		 * Vimeo		
		 **/		
		public function set vimeoConsumerKey( value:String ):void
		{
			_vimeoConsumerKey = value;
		}
		
		public function get vimeoConsumerKey():String
		{
			return _vimeoConsumerKey;
		}
		
		public function set vimeoID( value:Number ):void
		{
			_vimeoID = value;
		}
		
		public function get vimeoID():Number
		{
			return _vimeoID;
		}
	}
}