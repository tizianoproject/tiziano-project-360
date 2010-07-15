package org.tizianoproject.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	
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
			urlLoader.addEventListener( Event.COMPLETE, onXMLLoaded );
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			urlLoader.load( new URLRequest( path ) );			
		}
		
		/**********************************
		 * Public Methods
		 **********************************/
		public function getXMLData():XMLList
		{
			return xmlData;
		}

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onXMLLoaded( e:Event ):void
		{			
			xmlData = new XMLList( e.currentTarget.data );
			
			_data = new Array();
			for( var i:uint = 0; i < _xmlList.length(); i++ ){
				_data.push( _xmlList[i] );
			}
			
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