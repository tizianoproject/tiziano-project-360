/*
Copyright (c) 2007 Antti Kupila.
URL: http://www.anttikupila.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package com.anttikupila.utils {
	
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Endian;
	
	public class JPGSizeExtractor extends URLStream {
		
		// _________________________________________________________________________
		// CLASS CONSTANTS
		
		/**
		 * JPEG Start Of Frame 0 identifier FFC0 + length & bitdepth
		 */
		protected static const SOF0						: Array = [ 0xFF, 0xC0 , 0x00 , 0x11 , 0x08 ];
		/**
		 * Name of event that's dispatched when parse has completed
		 */
		public static const PARSE_COMPLETE				: String = "parseComplete";
		/**
		 * Name of event that's dispatched if no dimensions were found
		 */
		public static const PARSE_FAILED				: String = "parseFailed";
		
		// _________________________________________________________________________
		// VARIABLES
		
		protected var dataLoaded						: uint;
		protected var jpgWidth							: uint;
		protected var jpgHeight							: uint;
		protected var jumpLength						: uint;
		protected var stopWhenParseComplete				: Boolean;
		protected var traceDebugInfo					: Boolean;
		protected var address							: int;
		
		private static var APPSections					: Array;
	
		// _________________________________________________________________________
		// CONSTRUCTOR
		
		/**
		 * Can load a jpg stream until the first frame of the JPG (contains image dimensions) is found
		 */
		function JPGSizeExtractor( ) {
			endian = Endian.BIG_ENDIAN;
			
			if ( !APPSections ) {
				APPSections = new Array( );
				for ( var i : int = 1; i < 16; i++ ) {
					APPSections[ i ] = [ 0xFF, 0xE0 + i ];
				}
			}
		}
		
		// _________________________________________________________________________
		// PROTECTED METHODS
		
		/**
		 * Easy way to skip bytes, since URLStream doesn't have position implemented as in ByteArray
		 */
		protected function jumpBytes( count : uint ) : void {
			for ( var i : uint = 0; i < count; i++ ) {
				readByte( );
				address++;
			}	
			if ( traceDebugInfo ) trace( "Position after jump: 0x" + Number( address ).toString( 16 ).toUpperCase( ) );
		}
		
		// _________________________________________________________________________
		// EVENT HANDLERS
		
		/**
		 * Handles the data input, parses dimensions and dispatches the event <code>JPGSizeExtractor.PARSE_COMPLETE</code> when found.
		 */
		protected function progressHandler( e : ProgressEvent ) : void {
			dataLoaded = bytesAvailable;
			var index : uint = 0;
			var byte : int = 0;
			while ( bytesAvailable >= SOF0.length + 4 ) {
				var match : Boolean = false;
				// Only look for new APP table if no jump is in queue
				if ( jumpLength == 0 ) {
					byte = readUnsignedByte( );
					address++;
					// Check for APP table
					for each ( var APP : Array in APPSections ) {
						if ( address > 0x3200 && address < 0x3300 ) trace( byte + " @" + index + " == " + APP[ index ] + " -> " + ( byte == APP[ index ] ) );
						if ( byte == APP[ index ] ) {
							match = true;
							if ( index+1 >= APP.length ) {
								if ( traceDebugInfo ) trace( "APP" + Number( byte - 0xE0 ).toString( 16 ).toUpperCase( ) +  " found at 0x" + ( address - 2 ).toString( 16 ).toUpperCase( ) );
								// APP table found, skip it as it may contain thumbnails in JPG (we don't want their SOF's)
								jumpLength = readUnsignedShort( ) - 2; // -2 for the short we just read
								address += 2;
								break;
							}
						}
					}
				}
				// Jump here, so that data has always loaded
				if ( jumpLength > 0 ) {
					if ( traceDebugInfo ) trace( "Trying to jump " + jumpLength + " bytes (available " + Math.round( Math.min( bytesAvailable / jumpLength, 1 ) * 100 ) + "%)" );
					if ( bytesAvailable >= jumpLength ) {
						if ( traceDebugInfo ) trace( "Jumping " + jumpLength + " bytes to 0x" + Number( address + jumpLength ).toString( 16 ).toUpperCase( ) );
						jumpBytes( jumpLength );
						match = false;
						jumpLength = 0;
						index = 0;
					} else break; // Load more data and continue
				} else {
					// Check for SOF
					if ( byte == SOF0[ index ] ) {
						match = true;
						if ( index+1 >= SOF0.length ) {
							// Matched SOF0
							if ( traceDebugInfo ) trace( "SOF0 found at 0x" + address.toString( 16 ).toUpperCase( ) );
							jpgHeight = readUnsignedShort( );
							address += 2;
							jpgWidth = readUnsignedShort( );
							address += 2;
							if ( traceDebugInfo ) trace( "Dimensions: " + jpgWidth + " x " + jpgHeight );
							removeEventListener( ProgressEvent.PROGRESS, progressHandler ); // No need to look for dimensions anymore
							if ( stopWhenParseComplete && connected ) close( );
							dispatchEvent( new Event( PARSE_COMPLETE ) );
							break;
						}
					}
					if ( match ) {
						index++;
					} else {
						index = 0;
					}
				}
			}
		}
		
		/**
		 * Dispatched <code>JPGSizeExtractor.PARSE_FAILED</code> if end of file is reached, but no dimensions have been found
		 */
		protected function fileCompleteHandler( e : Event ) : void {
			if ( !jpgWidth || jpgHeight ) dispatchEvent( new Event( PARSE_FAILED ) );
		}
		
		// _________________________________________________________________________
		// PUBLIC API METHODS
		
		/**
		 * Starts extracting the data from the JPEG file. The event <code>JPGSizeExtractorEvent.PARSE_COMPLETE</code> will be fired when the size has been found.
		 * Note: JPGSizeExtractor does <strong>not</strong> check if the file is a valid JPEG file.
		 * 
		 * @param fileURL The path to the jpg file
		 * @param stopWhenParsed Stop loading the file when the dimensions have been parsed. Default = true
		 */
		public function extractSize( fileURL : String, stopWhenParsed : Boolean = true ) : void {
			addEventListener( ProgressEvent.PROGRESS, progressHandler );
			addEventListener( Event.COMPLETE, fileCompleteHandler );
			address = 0;
			dataLoaded = 0;
			jumpLength = 0;
			if ( traceDebugInfo ) trace( "Started loading '" + fileURL + "'" );
			stopWhenParseComplete = stopWhenParsed;
			super.load( new URLRequest( fileURL ) );
		}
		
		/**
		 * The amount of data that has been loaded
		 */
		public function get loaded( ) : uint {
			return dataLoaded;
		}
		
		/**
		 * The width of the parsed image 
		 */
		public function get width( ) : uint {
			return jpgWidth;
		}
		
		/**
		 * The height of the parsed image 
		 */
		public function get height( ) : uint {
			return jpgHeight;
		}
		
		/**
		 * Specifies if JPGSizeExtractor should trace debug information
		 */
		public function set debug( newDebug : Boolean ) : void {
			traceDebugInfo = newDebug;
		}
		
		/**
		 * @private
		 */
		public function get debug( ) : Boolean {
			return traceDebugInfo;
		}
	}
}