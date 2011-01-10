package com.mobex.map.marker
{
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.MarkerOptions;
	import com.mobex.map.VayuuMapWrapper;
	import com.mobex.map.event.MarkerSelectEvent;
	import com.mobex.map.marker.tab.VayuuInfoPanel;
	
	import flash.events.Event;
	
	import model.Airport;
	
	import mx.effects.Glow;
	import mx.effects.easing.Sine;
	
	public class AirportMarker extends ClusterableMarker
	{
		private var _panel:VayuuInfoPanel = null;
		private var _airport:Airport;
		[Embed(source="assets/single.png")]
		public var AirportIcon:Class;  
		
		[Embed(source="assets/single.png")]
		public var SelectedAirportIcon:Class;  

		
		public function AirportMarker(airport:Airport)
		{
			var latlng:LatLng = new LatLng( Number(airport.latitude), Number(airport.longitude));
			this._airport = airport;	
			
			super(latlng);
			
			setOptions(new MarkerOptions({
				icon : new AirportIcon(),
				iconAlignment: MarkerOptions.ALIGN_BOTTOM,
				hasShadow: false
			}));
			addEventListener(MapMouseEvent.CLICK, openAirportInfoWindow);			
		}
		
		private function openAirportInfoWindow(e:MapMouseEvent):void			
		{
			var map:Map = this.pane.map as Map;

			var event:MarkerSelectEvent = new MarkerSelectEvent(MarkerManager.MARKER_SELECT_EVENT);
			event.selectedMarker = this;
			map.dispatchEvent(event);

			select();
		}
		
		public function get airport():Airport
		{
			return _airport;
		}
		
		public function select():void{
			setOptions(new MarkerOptions({
				icon : new SelectedAirportIcon(),
				iconAlignment: MarkerOptions.ALIGN_BOTTOM,
				hasShadow: false
			}));
			
			var glowEffect:Glow = new Glow();
			glowEffect.alphaFrom = 1;
			glowEffect.alphaTo = 0.5;
			glowEffect.blurXFrom = 0;
			glowEffect.blurXTo = 400;
			glowEffect.blurYFrom = 0;
			glowEffect.blurYTo = 400;
			glowEffect.color = 0xF0000F;
			glowEffect.duration = 1000;
			glowEffect.strength = 3;
			glowEffect.target = this.foreground;
			
			glowEffect.easingFunction = Sine.easeIn;
			glowEffect.play();
		}
		
		public function unSelect():void{
			
			setOptions(new MarkerOptions({
				icon : new AirportIcon(),
				iconAlignment: MarkerOptions.ALIGN_BOTTOM,
				hasShadow: false
			}));
			var map:Map = this.pane.map as Map;
			var event:Event = new Event(MarkerManager.MARKER_UNSELECT_EVENT);
			map.dispatchEvent(event);
		}

		public function get popup():VayuuInfoPanel
		{
			return _panel;
		}

		public function set popup(value:VayuuInfoPanel):void
		{
			_panel = value;
		}

		
	}
}