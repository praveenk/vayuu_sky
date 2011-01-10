package com.mobex.map
{
	import com.google.maps.Map;
	import com.google.maps.MapMoveEvent;
	import com.mobex.map.marker.AirportMarker;
	import com.mobex.map.marker.tab.VayuuInfoPanel;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	
	public class VayuuMapWrapper
	{
		private var _selectedMarker:AirportMarker = null; 
		public static const MARKER_SELECT_EVENT:String = "MARKER_SELECT";
		public static const MARKER_UNSELECT_EVENT:String = "MARKER_UNSELECT";
		
		private var parentGroup:Group;
		private var _map:Map = null;
		private var mapRect:Rectangle = null;
		
		public function VayuuMapWrapper(map:Map)
		{
			_map = map;	
			mapRect = new Rectangle(_map.x, _map.y,_map.width, _map.height);
			_map.addEventListener(MapMoveEvent.MOVE_STEP, moveStep);
		}
		
		public function get selectedMarker():AirportMarker
		{
			return _selectedMarker;
		}
		
		public function set selectedMarker(value:AirportMarker):void
		{
			
			var panel:VayuuInfoPanel = null;
			parentGroup = _map.parent as Group;
			
			if (_selectedMarker != null && _selectedMarker == value){
				if (!(_selectedMarker.popup != null && parentGroup.contains(_selectedMarker.popup))){
					_selectedMarker.popup.resetInfoWindow();
					parentGroup.addElement(_selectedMarker.popup);
				}
				return;
			} 
			
			if (_selectedMarker == null){
				_selectedMarker = value;
			}
			
			
			if (_selectedMarker != null){
				panel = _selectedMarker.popup;
				
				if (panel != null && parentGroup.contains(panel)){
					parentGroup.removeElement(panel);
				}	
				_selectedMarker.unSelect();
				_selectedMarker = value;
				
				panel = _selectedMarker.popup;
				
				if (panel != null){
					panel.resetInfoWindow();
					parentGroup.addElement(panel);
				}else{
					panel = new VayuuInfoPanel();						
					panel.airport = _selectedMarker.airport;
					_selectedMarker.popup = panel;
					panel.resetInfoWindow();
					parentGroup.addElement(panel);
				}
				displayInfoPanelOnStage(panel);
			}
			
		}
		
		
		
		protected function displayInfoPanelOnStage(panel:VayuuInfoPanel):void{
			var point:Point = _selectedMarker.getDefaultPane(_map).fromLatLngToPaneCoords(_selectedMarker.getLatLng());
			var suggestedY:Number = point.y - panel.height - 15;
			var suggestedX:Number = point.x - panel.width/3;
			
			panel.x = suggestedX;
			panel.y = suggestedY;
			
		}
		
		private function moveStep(event:Event):void{
			if (_selectedMarker != null && _selectedMarker.popup != null){
				var panel:VayuuInfoPanel = _selectedMarker.popup;
				displayInfoPanelOnStage(panel)
			}
		}
	}
}