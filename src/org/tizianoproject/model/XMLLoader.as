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
	import flash.xml.XMLNode;
	
	import org.casalib.util.ArrayUtil;
	import org.tizianoproject.model.vo.Author;
	import org.tizianoproject.model.vo.Story;
	
	public class XMLLoader extends EventDispatcher implements IModel
	{
		private var _xmlData:XMLList;
		
		public function XMLLoader()
		{
		}
		
		public function load( path:String ):void
		{			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener( Event.COMPLETE, onXMLLoaded, false, 0, true );
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				urlLoader.load( new URLRequest( path ) );			
		}
		
		/**********************************
		 * Public Methods
		 **********************************/
		////////////////////////////////
		//Consumer KEYS
		////////////////////////////////
		private function getVimeoConsumerKey():String
		{
			return getConfig().child("vimeo_consumer_key").text();
		}
		
		private function getFlickrAPIKey():String
		{
			return getConfig().child("flickr_key").text();			
		}
		
		private function getSoundSlideURI():String
		{
			return getConfig().child("soundslide").child("uri").text();
		}
		
		public function getSoundSlideParams():String
		{
			return getConfig().child("soundslide").child("params").text();
		}
		
		////////////////////////////////
		//Authors
		////////////////////////////////
		//Used for ReportersView and AuthorsView
		public function getAuthorsByType( authorType:String, authorName:String=null, isRandom:Boolean=false ):Array
		{
			//trace( "XMLLoader::getAuthorsByType:", getAuthor().child("profile").(child("author_type") == authorType) );
			var profileList:XMLList = getAuthor().child("profile").(child("author_type") == authorType);
			var authors:Array = new Array();
			//trace( profileList.length() );
			for (var i:uint = 0; i < profileList.length(); i++){
				var author:Author = createAuthor( profileList[i] );
				//If there is an authorName:String and it matches an author.name in the array, don't use it
				if( authorName != author.name ) authors.push( author );
			}
			var array:Array = ( isRandom ) ? ArrayUtil.randomize( authors ) : authors; 
			return array;
		}

		public function getAuthorByName( authorName:String ):Author
		{
			//Filter all the authors a specific name
			var profileXML:XML = XML( getAuthor().child("profile").( child("name") == authorName ) );
			//Convert the XML into Author
			//trace( profileXML );
			var profile:Author = createAuthor( profileXML );
			return profile;
		}

		public function getAuthorTypeByName( authorName:String ):String
		{
			//trace( "getAuthorTypeByName:", getAuthorByName( authorName ).type );
			return getAuthorByName( authorName ).type;
		}		

		private function createAuthor( xml:* ):Author
		{
			var profile:XML	= xml;
			var author:Author 	= new Author();
			author.id			= ( profile.child("author_id") )			? profile.child("author_id") : -1;
			author.type			= ( profile.child("author_type").text() )	? profile.child("author_type").text() : "";
			author.avatar		= ( profile.child("avatar").text() )		? profile.child("avatar").text() : "";
			author.name			= ( profile.child("name").text() )			? profile.child("name").text() : "";
			author.city			= ( profile.child("city").text() )			? profile.child("city").text() : "";
			author.region		= ( profile.child("country").text() )		? profile.child("country").text() : "";
			author.age			= ( profile.child("age").text() )			? profile.child("age").text() : "";
			author.intro		= ( profile.child("intro") )				? profile.child("intro") : "";
			//trace( author.id, author.avatar, author.name, author.city, author.region, author.age, author.intro );
			return author;
		}
		
		////////////////////////////////
		//Articles 
		////////////////////////////////
		public function getAllAuthorArticlesByID( uniqueID:Number ):Array
		{
			var primaryStory:Story = getArticleByArticleID( uniqueID );
			var otherStories:Array = getOtherArticlesByAuthorName( primaryStory.authorName, primaryStory.id );
				otherStories.unshift( primaryStory );
			return otherStories;
		}
		
		public function getOtherArticlesByAuthorName( authorName:String, storyID:Number ):Array
		{
			//trace( "XMLLoader::getOtherArticlesByAuthorName:" );
			var articles:XMLList = getAllArticles().( child("author") == authorName );
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = createStory( XMLList(articles[i]) );
				if( story.id != storyID ) stories.push( story );
			}
			
			return stories;
		}
		
		public function getAllArticlesByAuthorName( authorName:String ):Array
		{
			trace( "XMLLoader::getAllArticlesByAuthorName" );
			var articles:XMLList = getAllArticles().( child("author") == authorName );
			//Iterate through each XML Node and Create a Story Object, then Push an Array
			var stories:Array = new Array();
			for( var i:uint = 0; i < articles.length(); i++ ){
				//Push the Stories!
				var story:Story = createStory( XMLList(articles[i]) );
				stories.push( story );
			}
			return stories;
		}

		//Get Article By Article ID
		public function getArticleByArticleID( uniqueID:Number ):Story
		{
			//trace( "XMLLoader::getArticleByArticleID" );
			//Find the <article> based on it's <article><id>
			var article:XMLList = getAllArticles().( child("id") == uniqueID );
			//Create A Story Object based on <article>
			var story:Story = createStory( article ) as Story;
			return story;
		}
		
		//Create a Story Object from XML Node
		private function createStory( xml:XMLList ):Story
		{
			var article:XMLList = xml;
			//Generic Story Information
			var story:Story			= new Story();
				story.id			= ( Number(article.child("id").text()) )	? Number(article.child("id").text()) : -1;
				story.storyType		= ( article.child("type").text() )			? article.child("type").text() : "";
				story.title			= ( article.child("title").text() )			? article.child("title").text() : "";
				story.headline		= ( article.child("headline").text() )		? article.child("headline").text() : "";
				story.subheadline	= ( article.child("subheadline").text() )	? article.child("subheadline").text() : "";
				story.image			= ( article.child("image_small").text() )	? article.child("image_small").text() : "";
				story.authorName	= ( article.child("author").text() )		? article.child("author").text() : "";
				story.sound			= ( article.child("audio_wall").text() )	? article.child("audio_wall").text() : "";
				story.bgImage		= ( article.child("image_bg").text() )		? article.child("image_bg").text() : "";
				story.authorType	= ( story.authorName )						? getAuthorTypeByName( story.authorName ) : "";

				//trace(  story.authorType );
				//trace( "XMLLoader::createStory:\n", story.id, story.storyType, story.title, story.headline, story.subheadline, story.image, story.authorName, story.authorType );

			//Specific Story Information
			switch( story.storyType ){
				case "article":
					story.content = article.child("content");
					break;
				case "video":
					story.vimeoConsumerKey = getVimeoConsumerKey();
					story.vimeoID = Number( article.child("vimeo_id").text() );
					break;
				case "photo":
					var uri:String = getSoundSlideURI();
					var path:String = article.child("path").text();
					var params:String = getSoundSlideParams();
					story.path = (uri + path + params);
					break;
				case "slideshow":
					story.flickrKey = getFlickrAPIKey();
					story.flickrPhotoset = article.child("flickr_photoset").text();
					break;
			}
			//trace( "XMLLoader::createStory:", story.path );
			
			//Get this Story's related <tags>
			var relatedTags:XMLList = article.child("tags").children();
			//If there are <tag>'s available, let's get this party started
			if( relatedTags.length() > 0 ){
				//Make sure that this story is not featured in the Related Stories
				story.related = getRelatedArticles( relatedTags, story.id );
			}
			return story;
		}

		private function getRelatedArticles( relatedTags:XMLList, primaryStoryID:Number ):Array
		{
			//trace( "XMLLoader::getRelatedArticles:" );
			//We're going to create an array filled with Story ID's
			var IDs:Array = new Array();
			//Iterate through each related <tag>
			for( var j:uint = 0; j < relatedTags.length(); j++ ){
				//First things first, let's collect every story's <tag>'s
				var allTags:XMLList = getAllTags();
				//Loop through every <tag>
				for( var k:String in allTags ){
					//If there is a match, find the <article><id>
					if( allTags[k] == relatedTags[j].text() ){
						var relatedArticle:XMLList = XMLList( allTags[k].parent().parent() );
						var id:Number = relatedArticle.child("id").text();
						IDs.push( id );
					}
				}
			}
			//Remove the Featured story from the Related Stories
			//Remove any Duplicate Featured Stories
			var array:Array = ArrayUtil.removeDuplicates( IDs );
			ArrayUtil.removeItem( array, primaryStoryID );
			//Randomize the Stories
			return ArrayUtil.randomize( array );
			//trace( "All Stories:", IDs.length, "Unique Stories:", story.related.length );			
		}
		
		/**********************************
		 * Private
		 **********************************/
		//Return all the Articles witin the XML
		private function getAllArticles():XMLList
		{
			return getXMLData().child("articles").descendants("article");
		}
		
		private function getAllTags():XMLList
		{
			return getAllArticles().child("tags").children();
		}
		
		private function getConfig():XMLList
		{
			return getXMLData().child("config");
		}
		
		//Private
		private function getAuthor():XMLList
		{
			return getXMLData().child("authors").descendants("author");
		}
		
		private function getXMLData():XMLList
		{
			return xmlData;
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onXMLLoaded( e:Event ):void
		{
			xmlData = new XMLList( e.currentTarget.data );

			dispatchEvent( new Event( Event.COMPLETE ) );			
		}
		
		private function securityErrorHandler (e:ErrorEvent):void
		{
			trace("securityErrorHandler:" + e.text);
		}
		
		private function ioErrorHandler(e:ErrorEvent):void
		{
			trace("ioErrorHandler: " + e.text);
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