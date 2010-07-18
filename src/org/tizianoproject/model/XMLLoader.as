package org.tizianoproject.model
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.tizianoproject.model.vo.Response;
	import org.tizianoproject.model.vo.Story;
	
	public class XMLLoader extends EventDispatcher
	{
		private var _data:Array;
		private var _xmlData:XMLList;
		
		public function XMLLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function load( path:String ):void
		{			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener( Event.COMPLETE, onXMLLoaded, false, 0, true );
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				urlLoader.load( new URLRequest( path ) );			
		}
		
		/**********************************
		 * Public Methods
		 **********************************/
		public function getVimeoConsumerKey():String
		{
			return getConfig().child("vimeo_consumer_key").text();
		}
		
		public function getFlickrAPIKey():String
		{
			return getConfig().child("flickr_key").text();			
		}
		
		//Used for Directory LIstings
		public function getAuthorsByType( authorType:String ):XMLList
		{
			return getAuthor().(attribute("type") == authorType);
		}
		
		public function getAuthorByFirstName( firstName:String ):XMLList
		{
			return getAuthor().profile.(first_name == firstName ).parent();
		}
		
		public function getArticlesByAuthor(  firstName:String ):XMLList
		{
			return getAuthor().profile.(first_name == firstName ).parent().child("articles").article;			
		}

		public function getArticlesByAuthorID(  uniqueID:Number ):XMLList
		{
			return getAuthor().(attribute("id") == uniqueID).child("articles").article;
		}

		//Provides <Profile> <Articles>
		public function getAllByArticleID( uniqueID:Number ):XMLList
		{
			return getAllArticles().( attribute("id") == uniqueID ).parent().parent().children();
		}
		
		//Get Author Information based on their Article
		public function getAuthorByArticleID( uniqueID:Number ):XMLList
		{
			return getAllArticles().( attribute("id") == uniqueID ).parent().parent().child("profile");
		}
		
		//Get the Responses from a particular Article
		public function getResponsesByArticleID( uniqueID:Number ):XMLList
		{
			return getAllArticles().( attribute("id") == uniqueID ).child("responses");
		}
		
		//Convert the XML into a Story Object
		public function getStory( xml:* ):Story
		{
			//Generic Story Information
			var story:Story			= new Story();
				story.id			= xml.attribute("id");
				story.storyType		= xml.attribute("type");
				story.title			= xml.title.text();
				story.headline		= xml.headline.text();
				story.subheadline	= xml.subheadline.text();
				story.image			= xml.image_small.text();
				story.authorName	= getFullName( getAuthorByArticleID( story.id ).first_name.text(), 
									  getAuthorByArticleID( story.id ).last_name.text() );
				story.authorType	= getAuthorByArticleID( story.id ).parent().attribute("type");
			//trace( 	story.id, story.storyType, story.title, story.headline, story.subheadline, story.image, story.authorName, story.authorType );
				
			//Specific Story Information
			switch( story.storyType ){
				case "text":
					story.content = xml.content.text();
					break;
				case "video":
					story.vimeoConsumerKey = getVimeoConsumerKey();
					story.vimeoID = xml.vimeo_id.text();
					break;
				case "slideshow":
					story.flickrKey = getFlickrAPIKey();
					story.flickrPhotoset = xml.flickr_photoset.text();
					break;
				case "soundslide":
					story.path = xml.path.text();
					break;
			}
			
			//Related Stories / Responses
			var totalResponses:Number = xml.responses.children().length();
			if( totalResponses > 0 ){
				story.responses = new Array();
				for( var j:uint = 0; j < totalResponses; j++ ){
					var response:Response = new Response();
						response.storyID = xml.child("responses").child("response")[j].attribute("id")
					//trace( response.storyID );
					story.responses.push( response );
				} 
			}
			return story;
		}

		//Collect the other articles
		public function getOtherArticlesByArticleID( uniqueID:Number ):Array
		{
			//Grab all the XMLLIst Stories
			var articles:XMLList = getAllArticles().( attribute("id") == uniqueID ).parent().descendants("article");
			
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = getStory( articles[i] );
				if( story.id != uniqueID ) stories.push( story );
			}
			return stories;
		}
		
		//Collect the other articles
		public function getAllArticlesByArticleID( uniqueID:Number ):Array
		{
			//Grab all the XMLLIst Stories
			var articles:XMLList = getAllArticles().( attribute("id") == uniqueID ).parent().descendants("article");
			
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = getStory( articles[i] );
				stories.push( story );
			}
			return stories;
		}
		

		//Get Article Information + Responses
		public function getArticleByArticleID( uniqueID:Number ):Story
		{
			var article:XMLList = getAllArticles().( attribute("id") == uniqueID );
			var story:Story = getStory( article  ) as Story;
			return story;
		}		
		
		/**********************************
		 * Private
		 **********************************/
		//Return all the Articles witin the XML
		private function getAllArticles():XMLList
		{
			return getXMLData().authors.descendants("article");
		}
		
		private function getConfig():XMLList
		{
			return getXMLData().config;
		}
		
		//Private
		private function getAuthor():XMLList
		{
			return getXMLData().authors.author;
		}
		
		private function getXMLData():XMLList
		{
			return xmlData;
		}
		
		private function getFullName( firstName:String, lastName:String ):String
		{
			return firstName + " " + lastName;
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onXMLLoaded( e:Event ):void
		{
			xmlData = new XMLList( e.currentTarget.data );
			//Get all the "Reporters" or the "Mentors"
			//trace( getAuthorsByType( "reporter" ) );
			//Get the data from the Reporter named "zana"
			//trace( getAllByArticleID( 1 ) );
			
			/*
			_data = new Array();
			for( var i:uint = 0; i < xmlData.length(); i++ ){
				_data.push( xmlData[i] );
			}
			*/
			//Fire once the XML has been converted into Image Objects
			dispatchEvent( new Event( Event.COMPLETE ) );			
		}
		
		private function httpStatusHandler (e:Event):void
		{
			//trace("httpStatusHandler:" + e);
		}
		
		private function securityErrorHandler (e:Event):void
		{
			trace("securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler(e:Event):void
		{
			trace("ioErrorHandler: " + e);
		}
		
		private function progressHandler(e:Event):void
		{
			//trace(e.currentTarget.bytesLoaded + " / " + e.currentTarget.bytesTotal);
		}
		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		private function set xmlData( value:XMLList ):void
		{
			_xmlData = value;
		}
		
		private function get xmlData():XMLList
		{
			return _xmlData;
		}		
	}
}