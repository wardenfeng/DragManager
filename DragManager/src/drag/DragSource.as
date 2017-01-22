package drag
{

	/**
	 * 拖拽源
	 * @author feng		2017-01-22
	 */
	public class DragSource
	{
		/**
		 * 数据拥有者
		 */
		private var dataHolder:Object = {};

		/**
		 * 格式处理函数列表
		 */
		private var formatHandlers:Object = {};

		/**
		 * 格式列表
		 */
		private var _formats:Array = [];

		/**
		 * 格式列表
		 */
		public function get formats():Array
		{
			return _formats;
		}

		/**
		 * 添加数据
		 * @param data			数据
		 * @param format		数据格式
		 */
		public function addData(data:Object, format:String):void
		{

			_formats.push(data);
			dataHolder[format] = data;
		}

		/**
		 * 添加处理函数
		 * @param handler
		 * @param format
		 */
		public function addHandler(handler:Function, format:String):void
		{

			_formats.push(format);
			formatHandlers[format] = handler;
		}

		/**
		 * 根据格式获取数据
		 * @param format		格式
		 * @return 				拥有的数据或者处理回调函数
		 */
		public function dataForFormat(format:String):Object
		{

			var data:Object = dataHolder[format];
			if (data)
				return data;
			if (formatHandlers[format])
				return formatHandlers[format]();
			return null;
		}

		/**
		 * 判断是否支持指定格式
		 * @param format			格式
		 * @return
		 */
		public function hasFormat(format:String):Boolean
		{
			var n:int = _formats.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_formats[i] == format)
					return true;
			}
			return false;
		}
	}
}
