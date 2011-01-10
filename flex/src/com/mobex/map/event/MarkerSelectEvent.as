package com.mobex.map.event
{
	import com.mobex.map.marker.AirportMarker;
	
	import flash.events.Event;
	
	public class MarkerSelectEvent extends Event
	{
		private var _selectedMarker:AirportMarker;
		
		public function MarkerSelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get selectedMarker():AirportMarker
		{
			return _selectedMarker;
		}

		public function set selectedMarker(value:AirportMarker):void
		{
			_selectedMarker = value;
		}

	}
}