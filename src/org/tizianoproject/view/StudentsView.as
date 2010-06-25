package org.tizianoproject.view
{
	import flash.display.MovieClip;
	
	public class StudentsView extends MovieClip
	{
		public function StudentsView()
		{
		}
		
		private function createTable():void
		{
			var columns:Number = 4;
			for( var i:Number = 0; i < 10; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);				
			}
		}
	}
}