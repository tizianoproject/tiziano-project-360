/** -----------------------------------------------------------
* Flickr Loader
* -----------------------------------------------------------
* Description: Pulls the data out of a specific Flickr PhotoSet
* - ---------------------------------------------------------
* Created by: cmendez@tizianoproject.org
* Modified by: 
* Date Modified: June 20, 2010
* - ---------------------------------------------------------
* Copyright ©2008 
* - ---------------------------------------------------------
*
* Get PhotoSets
*  http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=4415d421495d5b59d8537c0937fcce38&format=json&photoset_id=72157620264339553
*
* Get Photo 
*  http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=4415d421495d5b59d8537c0937fcce38&format=json&photo_id=3653985391
*
*/

package com.chrisaiv.flickr
{
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	
	import src.utils.Image;

	public class FlickrPhotoSetLoader extends EventDispatcher
	{
		private var flickrRestRequest:FlickrRestRequest;
        private var _data:Array;
        
        private static const FLICKR_API:String = "4415d421495d5b59d8537c0937fcce38";

		public function FlickrPhotoSetLoader( target:IEventDispatcher=null )
		{
			super(target);
	        _data = new Array();

		}

		//A. First things first, load the PhotoSet Data which includes the ImageID and ImageTitles
        public function load( photoSetID:String ):void
        {
        	flickrRestRequestCall( "flickr.photosets.getPhotos", "photoset_id", photoSetID, onJSONLoaded );
        }
        
        //This generic FlickrRestRequest makes it easier to request both "getPhotos" and "getInfo" from the Flickr API
        private function flickrRestRequestCall( restMethod:String, restParam:String, id:String, callBack:Function ):void
        {
			var flickrRestRequest:FlickrRestRequest = new FlickrRestRequest();
	            flickrRestRequest.load( FLICKR_API, restMethod, restParam, id  );
	            flickrRestRequest.addEventListener( FlickrEvent.CUSTOM, callBack );
				flickrRestRequest.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
				flickrRestRequest.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
				flickrRestRequest.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				flickrRestRequest.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);        	
        }

		//B. Once that PhotoSet Data has been loaded, parse, the data and request the specific image data
        private function onJSONLoaded( e:FlickrEvent ):void
        {
			var json:Object = e.arg as Object;
	        var photos:Object = json.photoset.photo as Object;
	        
	        //B-1. Loop through each Image of the PhotoSet
//	        for( var i:uint; i < photos.length; i++ ){
			//B-1 !!! We don't want more than 3 images to ever load so hard code the loop
	        for( var i:uint; i < 3; i++ ){
		       	//trace( "Order: " + i + " " + photos[i].title );   

				//B-2. Individually request the individual Image data ( flickr.photos.getInfo )
				flickrRestRequestCall( "flickr.photos.getInfo", "photo_id", photos[i].id, onGetInfoComplete );

				//B-3. Keep the Photos in the original PhotoSet order so start up an array
				//Image( index, Flickr Title );
		       	var image:Image = new Image( i, photos[i].id, photos[i].title );
		       	
		    	_data.push( image );		    	
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
	        
	        var tf:TextField = new TextField();
	        	tf.htmlText = description;
			var link:String = ( tf.text == "" ) ? "usc.edu/libraries" : tf.text;
			
			//C-2. If the Original Image can be accessed, use it, otherwise use the large image			
			var flickrSecret:String = (photo.originalsecret) ? photo.originalsecret + "_o" : photo.secret;
			//C-3. If you are using the original image, use it's original format.  Otherwise use JPG
			var flickrExt:String = (photo.originalformat) ? photo.originalformat : "jpg";

			//C-4.  Match the Image info with the Image stored in the Images:Array.
			for( var j:uint = 0; j < images.length; j++ ){
				//var regExp:RegExp = RegExp( photoCollection[i].id );
				var regExp:RegExp = new RegExp( images[j].id );
				//C-5. Once you've found a match, insert the new data into the Image Object
				if( id.match(regExp) ){
				//trace( images[j].caption, link );
					images[j].uri = link;
					images[j].src = "http://farm" + 
									photo.farm + ".static.flickr.com/" + 
									photo.server + "/" + 
									photo.id + "_" + 
									flickrSecret + "." + 
									flickrExt;
					//Announce to the Main application that an Image object is complete and ready to request the JPG			
			        dispatchEvent( new FlickrEvent( FlickrEvent.CUSTOM, images[j] ) );			
				}
			}
        }

		/***********************************
		 * Event Handlers :: Error Events
		***********************************/		
		public function get images():Array
		{
		        return _data;
		}
		
		/***********************************
		 * Event Handlers :: Error Events
		***********************************/
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