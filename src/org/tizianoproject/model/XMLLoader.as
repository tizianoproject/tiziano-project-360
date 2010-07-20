/**
 * -------------------------------------------------------
 * Model: XMLLoader 
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 7/18/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * This is the main model
 * 
 * */

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
	
	import org.casalib.util.ArrayUtil;
	import org.tizianoproject.model.vo.Author;
	import org.tizianoproject.model.vo.Response;
	import org.tizianoproject.model.vo.Story;
	
	public class XMLLoader extends EventDispatcher implements IModel
	{
		private var _data:Array;
		private var _xmlData:XMLList;
		
		public function XMLLoader()
		{
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
		////////////////////////////////
		//Consumer KEYS
		////////////////////////////////
		public function getVimeoConsumerKey():String
		{
			return getConfig().child("vimeo_consumer_key").text();
		}
		
		public function getFlickrAPIKey():String
		{
			return getConfig().child("flickr_key").text();			
		}
		
		////////////////////////////////
		//Authors
		////////////////////////////////
		public function getAuthorsByType( authorType:String ):Array
		{
//			trace( "XMLLoader::getAuthorsByType:", getAuthor().(attribute("type") == authorType) );
//			var xmlList:XMLList = getAuthor().(attribute("type") == authorType);
			//trace( "XMLLoader::getAuthorsByType:", getAuthor().child("profile").(child("author_type") == authorType) );
			var profileList:XMLList = getAuthor().child("profile").(child("author_type") == authorType);
			var authors:Array = new Array();
			for (var i:uint = 0; i < profileList.length(); i++){
				var author:Author = createAuthor( profileList[i] );
				authors.push( author );
			}			
			return authors;
		}
		
		private function createAuthor( xml:* ):Author
		{
			var profile:XML	= xml;
			var author:Author 	= new Author();
			author.id			= profile.child("author_id");
			author.avatar		= profile.child("avatar").text();
			author.name			= profile.child("name").text();
			author.city			= profile.child("city").text();
			author.region		= profile.child("country").text();
			author.age			= profile.child("age").text();
			author.intro		= profile.child("intro").text();
			//trace( author.id, author.avatar, author.name, author.city, author.region, author.age, author.intro );
			return author;
		}
		
		public function getAuthorByFirstName( firstName:String ):XMLList
		{
			return getAuthor().profile.(first_name == firstName ).parent();
		}
		
		public function getArticlesByAuthor(  firstName:String ):XMLList
		{
			return getAuthor().profile.(first_name == firstName ).parent().child("articles").article;			
		}

		public function getArticlesByAuthorID(  uniqueID:Number ):Array
		{
			//Find a Match
			var articlesList:XMLList = getAuthor().(attribute("id") == uniqueID).child("articles").article;
			//Generate Stories
			var articles:Array = new Array();
			for( var i:uint = 0; i < articlesList.length(); i++ ){
				var story:Story = new Story();
				articles.push( story );
			}
			return articles;
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
		
		////////////////////////////////
		//Articles 
		////////////////////////////////
		
		//Create a Story Object from XML Node
		public function createStory( xml:* ):Story
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
			//trace( "XMLLoader:createStory:", totalResponses );
			if( totalResponses > 0 ){
				story.responses = new Array();
				for( var j:uint = 0; j < totalResponses; j++ ){
					var response:Response = new Response();
						response.storyID = xml.child("responses").child("response")[j].attribute("id")
					story.responses.push( response );
				} 
			}
			return story;
		}

		//Get Article By Article ID
		public function getArticleByArticleID( uniqueID:Number ):Story
		{
			var article:XMLList = getAllArticles().( attribute("id") == uniqueID );
			var story:Story = createStory( article  ) as Story;
			return story;
		}		
		
		//Get Other Articles By Article ID
		public function getOtherArticlesByArticleID( uniqueID:Number ):Array
		{
			//Grab all the XMLLIst Stories
			var articles:XMLList = getAllArticles().( attribute("id") == uniqueID ).parent().descendants("article");
			
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = createStory( articles[i] );
				if( story.id != uniqueID ) stories.push( story );
			}
			return stories;
		}
		
		//Get All Articles By Article ID
		public function getAllArticlesByArticleID( uniqueID:Number ):Array
		{
			//Grab all the XMLLIst Stories
			var articles:XMLList = getAllArticles().( attribute("id") == uniqueID ).parent().descendants("article");
			
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = createStory( articles[i] );
				stories.push( story );
			}
			return stories;
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
			return getXMLData().child("authors").child("author");
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