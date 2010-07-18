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