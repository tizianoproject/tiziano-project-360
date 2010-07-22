/**
 * -------------------------------------------------------
 * Response Object
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 7/18/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * Response object is an association.  It's simply meant to keep track
 * of which stories are related to other stories
 * 
 * */

package org.tizianoproject.model.vo
{
	public class Response extends Object
	{
		private var _storyID:Number;
		
		public function Response()
		{
		}
		
		public function set storyID( value:Number ):void
		{
			_storyID = value
		}
		
		public function get storyID():Number
		{
			return _storyID;
		}
	}
}