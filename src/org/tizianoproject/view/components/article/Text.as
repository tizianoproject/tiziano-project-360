/**
 * -------------------------------------------------------
 * Text block
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: cmendez@tizianoproject.org
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
	import com.chrisaiv.utils.TextFormatter;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Text extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 34;
		private static const DEFAULT_Y_POS:Number = 110;
		private static const DEFAULT_TEXT:String = "Soluta nobis eleifend option congue nihil imperdiet doming id " + 
			"quod mazim. Zzril delenit augue duis dolore te feugait nulla facilisi nam liber. Decima et quinta " + 
			"decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Feugiat nulla facilisis " + 
			"at vero eros et accumsan et iusto odio dignissim! Amet consectetuer adipiscing elit sed diam nonummy " + 
			"nibh euismod tincidunt ut. Insitam est usus legentis in iis qui facit eorum claritatem Investigationes. " + 
			"Eum iriure dolor in hendrerit in vulputate velit esse molestie consequat vel illum dolore. Gothica quam " + 
			"nunc putamus parum claram anteposuerit litterarum formas humanitatis per et sans seacula quarta. Soluta " + 
			"nobis eleifend option congue nihil imperdiet doming id quod mazim. Zzril delenit augue duis dolore te " + 
			"feugait nulla facilisi nam liber. Decima et quinta decima eodem modo typi qui nunc nobis videntur parum " + 
			"clari fiant sollemnes in. Feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim! Amet " + 
			"consectetuer adipiscing elit sed diam nonummy nibh euismod tincidunt ut. Insitam est usus legentis in iis " + 
			"qui facit eorum claritatem Investigationes. Eum iriure dolor in hendrerit in vulputate velit esse molestie " + 
			"consequat vel illum dolore. Gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis " + 
			"per et sans seacula quarta.";
		
		public var text_txt:TextField;
		
		private var textHolder:MovieClip;
		private var textField:TextField;
		private var textScrollBar:Scroller;
		
		private var font:Font;

		public function Text()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
			
			initTextHolder();
			initTextField();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function initTextHolder():void
		{
			textHolder = new MovieClip();
			textHolder.x = 17;
			textHolder.y = 6;
			textHolder.graphics.beginFill( 0xffcc00, 0 );
			textHolder.graphics.drawRect( 0, 0, 408, 334 );
			textHolder.graphics.endFill();
			textHolder.useSmallTrack = true;
			ShowHideManager.addContent( (this as Text), textHolder );
			
		}

		private function initTextScrollBar():void
		{			
			textScrollBar = new Scroller( textHolder );
			textScrollBar.name = "textScrollBar";
			ShowHideManager.addContent( (this as Text), textScrollBar );
		}

		
		private function initTextField():void
		{
			font = new AGaramondSmallCaps();

			textField = new TextField();
			textField.name = "textField";
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = TextFormatter.returnTextFormat( font.fontName, 0xffffff, 18, 6 );
			textField.embedFonts = true;

			textField.selectable = false;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.mouseEnabled = true;
			//textField.border = true;
			//textField.borderColor = 0xffffff;

			textField.x = 0;
			textField.y = 0;
			textField.width = 408;

			textField.htmlText = DEFAULT_TEXT;
			ShowHideManager.addContent( textHolder, textField );
			
			initTextScrollBar();
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