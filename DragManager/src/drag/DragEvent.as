package drag
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * 拖拽事件
	 * @author feng		2017-01-22
	 */
	public class DragEvent extends Event
	{

		/**
		 * 拖拽放下事件
		 */
		public static const DRAG_DROP:String = "dragDrop";

		/**
		 * 拖入事件
		 */
		public static const DRAG_ENTER:String = "dragEnter";

		/**
		 * 拖出事件
		 */
		public static const DRAG_EXIT:String = "dragExit";

		/**
		 * 拖拽发起对象
		 */
		public var dragInitiator:DisplayObject;

		/**
		 * 拖拽源
		 */
		public var dragSource:DragSource;

		/**
		 * 构建拖拽事件
		 * @param type						事件类型
		 * @param dragInitiator				拖拽发起对象
		 * @param dragSource				拖拽源
		 * @param bubbles					是否冒泡
		 * @param cancelable				能否取消事件传播
		 */
		public function DragEvent(type:String, dragInitiator:DisplayObject = null, dragSource:DragSource = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.dragInitiator = dragInitiator;
			this.dragSource = dragSource;
		}
	}
}
