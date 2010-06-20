package com.chrisaiv.flickr
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class FlickrLoader extends EventDispatcher
	{
		private var _data:Array;
		
		private static const FLICKR_API:String = "4415d421495d5b59d8537c0937fcce38";
		
		public function FlickrLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function load( photoSetID:String ):void
		{
			
			var urlVars:URLVariables = new URLVariables();
			urlVars.method = "flickr.photosets.getPhotos";
			urlVars.api_key = FLICKR_API;
			urlVars.photoset_id = photoSetID;
			urlVars.format = "json";
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = "http://api.flickr.com/services/rest/";
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = urlVars;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, onJSONLoaded );
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			urlLoader.load( urlRequest );
		}
		
		private function onJSONLoaded( e:Event ):void
		{
			_data = new Array();
			
			var rawData = e.currentTarget.data as String;
			var data:String = rawData.slice( rawData.indexOf("{"), rawData.lastIndexOf("}") + 1 );
			//			trace( data );
			var json:Object = JSON.decode( data ) as Object;
			var photos:Object = json.photoset.photo as Object;
			
			//Create new image objects
			for( var i:uint; i < photos.length; i++ ){
				_data.push({ 
					"title" : photos[i].title.toString(), 
					"url" : "http://farm" + 
					photos[i].farm + 
					".static.flickr.com/" + 
					photos[i].server + "/" + 
					photos[i].id + "_" + 
					photos[i].secret + ".jpg" 
				});
			}
			
			//Fire once the XML has been converted into Image Objects
			dispatchEvent( new Event( Event.COMPLETE ) ); 
		}
		
		public function getImageData():Array
		{
			return _data;
		}
		
		private function httpStatusHandler ( e:HTTPStatusEvent ):void
		{
			//trace("httpStatusHandler:" + e);
		}
		
		private function securityErrorHandler ( e:SecurityErrorEvent ):void
		{
			trace("securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace("ioErrorHandler: " + e);
		}
		
		private function progressHandler( e:ProgressEvent ):void
		{
			//trace(e.currentTarget.bytesLoaded + " / " + e.currentTarget.bytesTotal);
		}
		
	}
}