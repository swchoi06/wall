package eventing.events
{
import components.Composite;

import eventing.eventdispatchers.IEventDispatcher;

public class CompositeEvent extends Event
{
	public static const CHILD_ADDED:String = "childAdded";
	public static const CHILD_REMOVED:String = "childRemoved";
	public static const ADDED:String = "added";
	public static const REMOVED:String = "removed";
	
	private var _child:Composite;
	private var _index:int;
	
	public function get child():Composite { return _child; }
	public function get index():int { return _index; }
	
	public function CompositeEvent(dispatcher:IEventDispatcher, type:String, child:Composite = null, index:int = -1)
	{
		super(dispatcher, type);
		_child = child;
		_index = index;
	}
}
}