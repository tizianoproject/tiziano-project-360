package org.tizianoproject.model.vo
{
	public class Story extends Object
	{
		private var _id:Number;
		private var _author:String;
		private var _title:String;
		private var _type:String;
		private var _image:String;
		private var _headline:String;
		private var _subheadline:String;
		private var _caption:String;
		private var _perspectives:Array;
		private var _flickrID:Number;
		private var _vimeoConsumerKey:String;
		private var _vimeoID:Number;
		private var _path:String;
		
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
		
		public function set author( value:String ):void
		{
			_author = value	
		}
		
		public function get author():String
		{
			return _author;
		}
		
		public function set title( value:String ):void
		{
			_title = value;	
		}
		
		public function get title():String
		{
			return _title;
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
		
		public function set perspectives( value:Array ):void
		{
			_perspectives = value;	
		}
		
		public function get perspectives():Array
		{
			return _perspectives;	
		}
		
		public function set path( value:String ):void
		{
			_path = value;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function set flickrID( value:Number ):void
		{
			_flickrID = value;	
		}
		
		public function get flickrID():Number
		{
			return _flickrID;	
		}
		
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