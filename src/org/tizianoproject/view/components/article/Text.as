/**
 * -------------------------------------------------------
 * Text block
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 6/16/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * This will write HTML content
 * 
 * */

package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Text extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 34;
		private static const DEFAULT_Y_POS:Number = 110;
		private static const DEFAULT_TEXT:String = "Soluta nobis eleifend option congue nihil imperdiet doming id quod mazim. Zzril delenit augue duis dolore te feugait nulla facilisi nam liber. Decima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim! Amet consectetuer adipiscing elit sed diam nonummy nibh euismod tincidunt ut. Insitam est usus legentis in iis qui facit eorum claritatem Investigationes. Eum iriure dolor in hendrerit in vulputate velit esse molestie consequat vel illum dolore. Gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis per et sans seacula quarta.";
		
		public var text_txt:TextField;

		public function Text()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
			writeText( DEFAULT_TEXT );
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			//trace( "Text::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "Text::onRemovedFromStageHandler:" );
			ShowHideManager.unloadContent( (this as Text ) );
		}		

		public function writeText( string:String ):void
		{
			text_txt.htmlText = string;
		}
		
		public function clearText():void
		{
			text_txt.text = "";
		}
	}
}