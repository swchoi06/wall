package cream.components
{
import eventing.eventdispatchers.ICompositeEventDispatcher;
import eventing.eventdispatchers.IDimensionChangeEventDispatcher;
import eventing.eventdispatchers.IExternalDimensionChangeEventDispatcher;
import eventing.eventdispatchers.IFocusEventDispatcher;

import flash.geom.Point;

public interface IComponent extends ICompositeEventDispatcher, IDimensionChangeEventDispatcher, IFocusEventDispatcher, IExternalDimensionChangeEventDispatcher
{
	function get width():Number;
	function set width(val:Number):void;
	function get height():Number;
	function set height(val:Number):void;
	function get percentWidth():Number; 
	function get percentHeight():Number;
	function set percentWidth(val:Number):void;
	function set percentHeight(val:Number):void;
	
	function resize(w:Number, h:Number):void;
	
	function globalToLocal(point:Point):Point;
	function localToGlobal(point:Point):Point;
}
}