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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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

		//Collect the other articles
		public function getAllArticlesByArticleID( uniqueID:Number ):XMLList
		{
			var articles:XMLList = getAllArticles().( attribute("id") == uniqueID ).parent().descendants("article");
			var totalArticles:Number = articles.length();
			trace( articles[0].title );

			var stories = new Array();
			for( var i:uint = 0; i < totalArticles; i++ ){
				
				//stories.push( xmlData[i] );
			}
			
			trace( "\n++++++++++++++++++++++++++++++++++++++\n" );
			return articles;
		}

		//Get Article Information + Responses
		public function getArticleByArticleID( uniqueID:Number ):XMLList
		{
			return getAllArticles().( attribute("id") == uniqueID );
		}		
		
		/**********************************
		 * Private
		 **********************************/
		//Return all the Articles witin the XML
		private function getAllArticles():XMLList
		{
			return xmlData.authors.descendants("article");
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