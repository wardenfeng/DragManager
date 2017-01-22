package drag
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 拖拽管理者
	 * @author feng 2017-01-22
	 *
	 */
	public class DragManager
	{

		/**
		 * 拖拽示例
		 */
		private static var _instance:DragManager;

		/**
		 * 拖拽管理者
		 */
		private static function get instance():DragManager
		{
			return _instance ||= new DragManager();
		}

		/**
		 * 是否正在拖拽
		 */
		public static function get isDragging():Boolean
		{
			return instance.isDragging;
		}

		/**
		 * 是否被接受
		 */
		public static function get isSuccess():Boolean
		{
			return instance.isSuccess;
		}

		/**
		 * 执行拖拽
		 * @param dragInitiator		拖拽发起对象
		 * @param dragSource		拖拽源
		 * @param mouseEvent		鼠标事件
		 * @param dragImagge		拖拽图片
		 * @param xOffset			X偏移
		 * @param yOffset			Y偏移
		 * @param imageAlpha		图片透明度
		 * @param allowMove			是否允许移动
		 */
		public static function doDrag(dragInitiator:DisplayObject, dragSource:DragSource, mouseEvent:MouseEvent, dragImagge:DisplayObject = null, xOffset:Number = 0, yOffset:Number = 0, imageAlpha:Number = 0.5, allowMove:Boolean = true):void
		{
			instance.doDrag(dragInitiator, dragSource, mouseEvent, dragImagge, xOffset, yOffset, imageAlpha, allowMove);
		}

		/**
		 * 接受拖入
		 * @param target		接受拖入的对象
		 */
		public static function acceptDragDrop(target:DisplayObject):void
		{

			instance.acceptDragDrop(target);
		}

		/**
		 * 是否接受拖入
		 */
		public static function isAcceptDragDrop(target:DisplayObject):Boolean
		{

			return instance.accepter == target;
		}

		/**
		 * 是否正在拖拽
		 */
		private var isDragging:Boolean;
		private var _accepter:DisplayObject;
		/**
		 * 拖拽发起对象
		 */
		private var dragInitiator:DisplayObject;
		/**
		 * 拖拽源
		 */
		private var dragSource:DragSource;
		/**
		 * 鼠标事件
		 */
		private var mouseEvent:MouseEvent;
		/**
		 * 拖拽图片
		 */
		private var dragImage:DisplayObject;
		/**
		 * X偏移
		 */
		private var xOffset:Number;
		/**
		 * y偏移
		 */
		private var yOffset:Number;
		/**
		 * 图片透明度
		 */
		private var imageAlpha:Number;
		/**
		 * 是否允许移动
		 */
		private var allowMove:Boolean;
		/**
		 * 舞台
		 */
		private var stage:Stage;
		/**
		 * 是否放入接受者中
		 */
		private var isSuccess:Boolean;

		/**
		 * 执行拖拽
		 * @param dragInitiator		拖拽发起对象
		 * @param dragSource		拖拽源
		 * @param mouseEvent		鼠标事件
		 * @param dragImagge		拖拽图片
		 * @param xOffset			X偏移
		 * @param yOffset			Y偏移
		 * @param imageAlpha		图片透明度
		 * @param allowMove			是否允许移动
		 */
		public function doDrag(dragInitiator:DisplayObject, dragSource:DragSource, mouseEvent:MouseEvent, dragImagge:DisplayObject = null, xOffset:Number = 0, yOffset:Number = 0, imageAlpha:Number = 0.5, allowMove:Boolean = true):void
		{
			this.isSuccess = false;
			this.dragInitiator = dragInitiator;
			this.dragSource = dragSource;
			this.mouseEvent = mouseEvent;
			this.dragImage = dragImage;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			this.imageAlpha = imageAlpha;
			this.allowMove = allowMove;
			this.stage = dragInitiator.stage;
			startDrag();
		}

		/**
		 * 接受拖入
		 * @param target		接受拖入的对象
		 */
		public function acceptDragDrop(target:DisplayObject):void
		{
			accepter = target;
		}

		/**
		 * 接受对象
		 */
		private function get accepter():DisplayObject
		{
			return _accepter;
		}

		private function set accepter(value:DisplayObject):void
		{
			if (_accepter)
			{
				_accepter.removeEventListener(MouseEvent.MOUSE_OUT, onAccepterMouseOut);
			}
			_accepter = value;
			if (_accepter)
			{
				_accepter.addEventListener(MouseEvent.MOUSE_OUT, onAccepterMouseOut);
			}
		}

		/**
		 * 开始拖拽
		 */
		private function startDrag():void
		{
			isDragging = true;
			accepter = null;
			addListeners();
			dragImage = dragImage || createDragImage();
			stage.addChild(dragImage);
			updateDragImage();
		}

		private function updateDragImage():void
		{
			dragImage.x = stage.mouseX + xOffset;
			dragImage.y = stage.mouseY + yOffset;
			dragImage.alpha = imageAlpha;
		}

		private function createDragImage():DisplayObject
		{
			var bound:Rectangle = dragInitiator.getBounds(dragInitiator);
			xOffset = bound.x - dragInitiator.mouseX;
			yOffset = bound.y - dragInitiator.mouseY;
			var bitmap:Bitmap = new Bitmap(new BitmapData(dragInitiator.width, dragInitiator.height, true, 0));
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -bound.x, -bound.y);
			bitmap.bitmapData.draw(dragInitiator, matrix);
			return bitmap;
		}

		private function endDrag():void
		{
			isDragging = false;
			removeListeners();
			accepter = null;
			stage.removeChild(dragImage);
			dragImage = null;
		}

		/**
		 * 处理接受对象鼠标移出事件
		 */
		protected function onAccepterMouseOut(event:MouseEvent):void
		{
			accepter.dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT, dragInitiator, dragSource, true));
			accepter = null;
		}

		/**
		 * 处理舞台鼠标移入事件
		 */
		protected function onStageMouseOver(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			target.dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER, dragInitiator, dragSource, true));
		}

		protected function onStageMouseUp(event:MouseEvent):void
		{
			if (accepter != null)
			{
				isSuccess = true;
				accepter.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, dragInitiator, dragSource, true));
			}
			endDrag();
		}

		protected function onStageMouseMove(event:MouseEvent):void
		{
			updateDragImage();
		}


		private function addListeners():void
		{
			stage.addEventListener(MouseEvent.MOUSE_OVER, onStageMouseOver);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}

		private function removeListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onStageMouseOver);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}

	}
}
