/** -----------------------------------------------------------
 * StudentsView
 * -----------------------------------------------------------
 * Description: Display all the students 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 *
 */

package org.tizianoproject.view
{
	import flash.display.MovieClip;
	
	public class ListingBrickView extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 65;
		private static const DEFAULT_Y_POS:Number = 71;
		
		public function ListingBrickView()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
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