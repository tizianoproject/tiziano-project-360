package org.tizianoproject.model
{
	import org.tizianoproject.view.FooterView;
	import org.tizianoproject.view.HeaderView;
	import org.tizianoproject.view.WallView;
	import org.tizianoproject.view.components.Background;

	public dynamic class MainObjectParams extends Object
	{
		private var _wallView:WallView;
		private var _footerView:FooterView;
		private var _headerView:HeaderView;
		private var _bg:Background;
		
		public function MainObjectParams()
		{
			
		}
		
		public function set wallView( value:WallView ):void
		{
			_wallView = value			
		}

		public function get wallView( ):WallView
		{
			return _wallView;	
		}

		public function set footerView( value:FooterView ):void
		{
			_footerView = value;
		}
		
		public function get footerView( ):FooterView
		{
			return _footerView;			
		}

		public function set headerView( value:HeaderView ):void
		{
			_headerView = value	
		}
		
		public function get headerView( ):HeaderView
		{
			return _headerView;
		}

		public function set bg( value:Background ):void
		{
			_bg = value;	
		}
		
		public function get bg( ):Background
		{
			return _bg;
		}

	}
}