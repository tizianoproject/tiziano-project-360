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
 * var students:Array = new Array("ashna-sm.jpg", "dilpak-sm.jpg", "mohamad-sm.jpg", "mustafa-sm.jpg", "rasi-sm.jpg", "rebin-sm.jpg", "sevina-sm.jpg", "shivan-sm.jpg", "zana-sm.jpg");
 * 
 */

package org.tizianoproject.view
{
	import flash.display.MovieClip;
	
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	
	public class ListingBrickView extends CompositeView
	{
		private static const DEFAULT_X_POS:Number = 65;
		private static const DEFAULT_Y_POS:Number = 71;
		
		public function ListingBrickView( m:IModel, c:IController=null )
		{
			super( m, c );
			
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

		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			trace( e.results.name, "::onBaseCloseHandler:" );
			dispatchEvent( e );
		}	

	}
}