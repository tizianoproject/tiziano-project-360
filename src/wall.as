/****************************
SWF Bridge
****************************/
import com.gskinner.utils.SWFBridgeAS2;

Stage.scaleMode="noScale";
//Align the stage to the top left
Stage.align = "TL";

var swfBridge = new SWFBridgeAS2("swfBridge", this);
	swfBridge.addEventListener("connect", onConnectHandler);

function swfMessage(message:String):Void {
	switch (message) {
		case "connect" :
			swfBridge.send( "swfBridgeConnect", "Sent From:",_url.substr(_url.lastIndexOf("/")) );
			break;
		case "fullScreen" :
			break;
		case "normal" :
			break;
	}
}

function onConnectHandler(e):Void {
	swfMessage("connect");
	//Load the XML Data
	loadXML();
}

function onScreenResize(param1):Void {
	trace( "WALL::onScreenResize: " );
	if (param1 == "fullScreen") {
		trace("wall::onFullScreenHandler: fullScreen");
		this._x = (Stage.width)/2-(this._width/2);
		this._y = (Stage.height)/2-(this._height/2);
	} else {
		this._x = 0;
		this._y = 0;
	}
}

/****************************
ThumbnailList Event Listeners
****************************/
var listener:Object = new Object();
listener.onPressThumb = function(xmlNode:Object, thumb:MovieClip, clipIndex:Number):Void  {
	swfBridge.send("onPressThumb",xmlNode,clipIndex);
};

listener.onRollOverThumb = function(xmlNode:Object, thumb:MovieClip, clipIndex:Number):Void  {
	swfBridge.send("onRollOverThumb",xmlNode,clipIndex);
};

listener.onRollOutThumb = function(xmlNode:Object, thumb:MovieClip, clipIndex:Number):Void  {
	swfBridge.send("onRollOutThumb",xmlNode,clipIndex);
};

listener.onLoadComplete = function(success:Boolean, totalThumbnails:Number, firstThumb:Object):Void  {
	//trace("onLoadComplete: "+success+" "+totalThumbnails+" "+firstThumb);
};

listener.onLoadXml = function(success:Boolean):Void  {
	//trace("onLoadXml: "+success);
};

listener.onLoadProgress = function(imagesLoaded:Number, totalImages:Number) {
	//trace("onLoadProgress: "+imagesLoaded+" "+totalImages);
};

/****************************
ThumbnailList Component
****************************/
var matrixProps:Object = new Object();
	matrixProps._x = 0;
	matrixProps._y = 0;
	matrixProps._width = Stage.width;
	matrixProps._height = Stage.height;

var main:MovieClip = this;	
	main.attachMovie("ThumbnailList", "matrix_mc", main.getNextHighestDepth(), matrixProps);
	
matrix_mc.backgroundColor = 0x000000;
matrix_mc.keepScrollButtonSize = false;
matrix_mc.setSize( Stage.width,Stage.height );
matrix_mc.displayEffect = "ordered show";
matrix_mc.matrix = { lines:10, columns:10 };
matrix_mc.rollOverEffect = "black&white";
matrix_mc.border = 0;
matrix_mc.preloader = "circle";
matrix_mc.preloaderColor = 0xFFFFFF;
matrix_mc.navigation = "mouse movement";
matrix_mc.background = false;
matrix_mc.thumbBorderSize = 0;
matrix_mc.thumbWidth = 201;
matrix_mc.thumbHeight = 139;
matrix_mc.thumbResizeType = "borderscale";
matrix_mc.thumbSpacing = 30;
matrix_mc.remainActiveOnPress = true;
// load the xml file and display the thumbs
matrix_mc.addListener(listener);
matrix_mc._visible = false;

function loadXML() {
}
matrix_mc._visible = true;
matrix_mc.load("http://demo.chrisaiv.com/xml/tiziano/jumpeye.xml");
