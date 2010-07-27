/** -----------------------------------------------------------
 * Feature Holder
 * -----------------------------------------------------------
 * Description: Hold the feature:Feature clips
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 * The purpose of FeatureHolder is to collect all the features 
 * and pass them through Scroller.
 *  
 */

package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.tizianoproject.view.CompositeView;
	
	public class FeatureHolder extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 530, 73 );
		private static const WIDTH:Number = 320;
		private static const HEIGHT:Number = 500;
		
		public var useSmallTrack:Boolean = false;
		
		public function FeatureHolder()
		{
			tabEnabled = false;
			
			x = DEFAULT_POS.x;
			y = DEFAULT_POS.y;			
		}
		
		override protected function init():void
		{
			initBackground();
		}
		
		private function initBackground():void
		{
			graphics.beginFill( 0xff00ff, 0 );
			graphics.drawRect( 0, 0, WIDTH, HEIGHT );
			graphics.endFill();			
		}
		
		override protected function unload():void
		{
		}
	}
}