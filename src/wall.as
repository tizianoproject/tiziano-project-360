import com.gskinner.utils.SWFBridgeAS2;
import flash.geom.Rectangle;

/****************************
Full Screen
****************************/
Stage.align = "TL";
Stage.scaleMode="noScale";

function goFullScreen():Void{
//	var scalingRect:Rectangle = new Rectangle( 0, 0, Stage.width, Stage.height );
//	Stage["fullScreenSourceRect"] = scalingRect;
	if(Stage["displayState"] == "normal"){
        Stage["displayState"] = "fullScreen";
    } else {
        Stage["displayState"] = "normal";
    }    
}

var fsListener:Object = new Object();
fsListener.onFullScreen = function( isFullscreen:Boolean ){
    if(isFullscreen){
		updateMatrixSize( Stage.width, Stage.height )
    }else{
		updateMatrixSize( Stage.width, Stage.height )
    }
}
Stage.addListener( fsListener );

/****************************
SWF Bridge
****************************/
var swfBridge = new SWFBridgeAS2("swfBridge", this);
	swfBridge.addEventListener("connect", onConnectHandler);

function swfMessage(message:String):Void {
	switch (message) {
		case "connect" :
			swfBridge.send( "swfBridgeConnect", "Sent From:",_url.substr(_url.lastIndexOf("/")) );
			break;
		case "fullScreen":
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
	/*
	trace( "WALL::onScreenResize: " + param1 );
	if (param1 == "fullScreen") {
		this._x = ( Stage.width ) / 2 - ( this._width / 2 );
		this._y = ( Stage.height ) / 2- ( this._height / 2 );
	} else {
		this._x = 0;
		this._y = 0;
	}
	*/
}

/****************************
ThumbnailList Event Listeners
****************************/
var listener:Object = new Object();
listener.onPressThumb = function(xmlNode:Object, thumb:MovieClip, clipIndex:Number):Void  {
	swfBridge.send("onPressThumb",xmlNode,clipIndex);
	goFullScreen();
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
var initWidth:Number = Stage.width;
var initHeight:Number = Stage.height;

var matrixProps:Object = new Object();
	matrixProps._x = 0;
	matrixProps._y = 0;
	matrixProps._width = initWidth;
	matrixProps._height = initHeight;

var main:MovieClip = this;
	main.attachMovie("ThumbnailList", "matrix_mc", main.getNextHighestDepth(), matrixProps );
	
matrix_mc.backgroundColor = 0x000000;
matrix_mc.keepScrollButtonSize = false;
matrix_mc.setSize( initWidth, initHeight );
matrix_mc.displayEffect = "ordered show";
matrix_mc.matrix = {  columns: 8 };
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
matrix_mc.addListener(listener);
matrix_mc._visible = false;

function updateMatrixSize( w:Number, h:Number ):Void
{
	matrix_mc.setSize( w, h );
}

function loadXML() {
}
matrix_mc._visible = true;
matrix_mc.load("http://demo.chrisaiv.com/xml/tiziano/jumpeye.xml");
//matrix_mc.load("http://localhost:8080/xml/tiziano/jumpeye.xml");
