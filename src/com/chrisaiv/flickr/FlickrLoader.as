/**
 * -------------------------------------------------------
 * Flickr Rest Request
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: cmendez@tizianoproject.org
 * Modified: 6/21/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * 
 * FlickrRest Request makes requests and awaits a JSON response.
 * 
 * 
<photo id="2733" secret="123456" server="12"
	isfavorite="0" license="3" rotation="90" 
	originalsecret="1bc09ce34a" originalformat="png">
	<owner nsid="12037949754@N01" username="Bees"
		realname="Cal Henderson" location="Bedford, UK" />
	<title>orford_castle_taster</title>
	<description>hello!</description>
	<visibility ispublic="1" isfriend="0" isfamily="0" />
	<dates posted="1100897479" taken="2004-11-19 12:51:19"
		takengranularity="0" lastupdate="1093022469" />
	<permissions permcomment="3" permaddmeta="2" />
	<editability cancomment="1" canaddmeta="1" />
	<comments>1</comments>
	<notes>
		<note id="313" author="12037949754@N01"
			authorname="Bees" x="10" y="10"
			w="50" h="50">foo</note>
	</notes>
	<tags>
		<tag id="1234" author="12037949754@N01" raw="woo yay">wooyay</tag>
		<tag id="1235" author="12037949754@N01" raw="hoopla">hoopla</tag>
	</tags>
	<urls>
		<url type="photopage">http://www.flickr.com/photos/bees/2733/</url> 
	</urls>
</photo>
 * 
 * 
 * 
 * 
 * */
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
	import flash.utils.describeType;
	
	public class FlickrLoader extends EventDispatcher
	{
		private static const USE_ORIGINAL_IMAGE:Boolean = false;
		
		private var flickrRestRequest:FlickrRestRequest;

		private var count:Number;

		private var _totalImages:Number;
		private var _photoSet:Array;
		private var _apiKey:String;
		
		public function FlickrLoader()
		{
			//This keeps track of the photo set
			photoSet = new Array();
			count = 0;
		}
		
		//A. First things first, load the PhotoSet Data which includes the ImageID and ImageTitles
		public function load( photoSetID:String ):void
		{
			flickrRequest( "flickr.photosets.getPhotos", "photoset_id", photoSetID, onGetPhotosComplete );
			//flickrRequest( "flickr.photosets.getPhotos", "photoset_id", photoSetID, onSimpleJSONLoaded );
		}
		
		//This generic FlickrRestRequest makes it easier to request both "getPhotos" and "getInfo" from the Flickr API
		private function flickrRequest( restMethod:String, restParam:String, id:String, callBack:Function ):void
		{
			var flickrRestRequest:FlickrRestRequest = new FlickrRestRequest();
			flickrRestRequest.load( apiKey, restMethod, restParam, id  );
			flickrRestRequest.addEventListener( FlickrEvent.CUSTOM, callBack );
			flickrRestRequest.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			flickrRestRequest.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			flickrRestRequest.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			flickrRestRequest.addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true);        	
		}
		
		//<photo id="4700578385" secret="21c998eca8" server="1280" farm="2" title="The First Lesson" isprimary="0"/>
		private function onGetPhotosComplete( e:FlickrEvent ):void
		{
			var json:Object = e.arg as Object;
			//This is actually an array but disguised as an object
			var photos:Object = json.photoset.photo as Object;
			
			//Total Photos
			totalImages = photos.length;
			
			for( var i:uint = 0; i < totalImages; i++ ){

				//Create an array of photo objects and keep them in original order
				var object:Object = new Object();
				//You will need photos[i].id to match onGetInfoComplete()
					object.id = photos[i].id 
						
				photoSet.push( object );
				//Now make a request for the photo data
				flickrRequest( "flickr.photos.getInfo", "photo_id", photos[i].id, onGetInfoComplete );
			}
		}

		//C. Gather all the Image information and organize everything
		private function onGetInfoComplete( e:FlickrEvent ):void
		{
			var json:Object = e.arg as Object;
			
			//C-1. Collect the id, title, description, uri, and url
			var photo:Object = json.photo;
			var id:String = photo.id;
			var title:String = photo.title._content.toString();
			var description:String = photo.description._content.toString();
			//trace( id, title, description );

			//C-2. If the Original Image can be accessed, use it, otherwise use the large image			
			var photoSecret:String = (photo.originalsecret && USE_ORIGINAL_IMAGE) ? photo.originalsecret + "_o" : photo.secret;
			//C-3. If you are using the original image, use it's original format.  Otherwise use JPG
			var photoExt:String = (photo.originalformat && USE_ORIGINAL_IMAGE) ? photo.originalformat : "jpg";

			//C-4.  Match the Image info with the Image stored in the Images:Array.
			for( var j:uint = 0; j < photoSet.length; j++ ){
				//var regExp:RegExp = RegExp( photoCollection[i].id );
				var regExp:RegExp = new RegExp( photoSet[j].id );
				if( id.match( regExp ) ){
					//Construct an Image URL
					photoSet[j].url = "http://farm" + 
					photo.farm + ".static.flickr.com/" + 
					photo.server + "/" + 
					photo.id + "_" + 
					photoSecret + "." + 
					photoExt;
					//Construct the Title
					photoSet[j].title = title;
					//Construct the Description
					photoSet[j].description = description;
					//Announce to the Main application that an Image object is complete and ready to request the JPG
					dispatchEvent( new FlickrEvent( FlickrEvent.CUSTOM, photoSet[j] ) );
				}
			}			
			
			addToCount( 1 );
		}
		
		private function addToCount( increment:Number ):void
		{
			count += increment;
			//ONce all the images + respectie data has loaded, Dispatch Event.COMPLETE
			if( count >= totalImages ) dispatchEvent( new Event( Event.COMPLETE ) );			
		}
		
		private function onSimpleJSONLoaded( e:Event ):void
		{
			var rawData = e.currentTarget.data as String;
			//Parse the Flickr javascript injection method
			var data:String = rawData.slice( rawData.indexOf("{"), rawData.lastIndexOf("}") + 1 );
			//			trace( data );
			var json:Object = JSON.decode( data ) as Object;
			var photos:Object = json.photoset.photo as Object;
			
			//Create new image objects
			for( var i:uint; i < photos.length; i++ ){
				photoSet.push({ 
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
		
		/************************************
		 * Event Handlers
		 ************************************/
		private function httpStatusHandler ( e:HTTPStatusEvent ):void
		{
			//trace("FlickrLoader::httpStatusHandler:" + e);
		}
		
		private function securityErrorHandler ( e:SecurityErrorEvent ):void
		{
			trace("FlickrLoader::securityErrorHandler:" + e);
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace("FlickrLoader::ioErrorHandler: " + e);
		}
		
		private function progressHandler( e:ProgressEvent ):void
		{
			//trace(e.currentTarget.bytesLoaded + " / " + e.currentTarget.bytesTotal);
		}
		
		/************************************
		 * Read / Write Accessors
		************************************/
		public function set photoSet( array:Array ):void
		{
			_photoSet = array;
		}
		
		public function get photoSet():Array
		{
			return _photoSet;
		}
		
		public function get totalImages():Number
		{
			return _totalImages;
		}
		
		public function set totalImages( number:Number ):void
		{
			_totalImages = number;
		}

		public function set apiKey( string:String ):void
		{
			_apiKey = string;
		}
		
		public function get apiKey():String
		{
			return _apiKey;
		}
	}
}