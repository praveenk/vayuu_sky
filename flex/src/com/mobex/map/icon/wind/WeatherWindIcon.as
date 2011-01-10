package com.mobex.map.icon.wind
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import spark.components.Label;
	import spark.primitives.Line;
	
	public class WeatherWindIcon extends Sprite
	{
		private var colorRef:Array = [0x21006b,0x4a006b,0x4a006b,0x4a006b,0x660066,0x660066,
			0x660066,0x840084,0x840084,0x840084,0x990099,0x990099,0xc537c5,0xc537c5,0xc537c5,0xcc00cc,0xcc00cc,
			0xe700e7,0xe700e7,0xe700e7,0xff00ff,0xff00ff,0xff00ff,0xd600ff,0xd600ff,0xd600ff,0xd600ff,0x9900ff,
			0x9900ff,0x9900ff,0x6600ff,0x6600ff,0x6600ff,0x0000ff,0x0000ff,0x0000ff,0x0049ff,0x0049ff,0x0049ff,
			0x0049ff,0x0075ff,0x00a2ff,0x00a2ff,0x00a2ff,0x00a2ff,0x00ccff,0x00ccff,0x00ccff,0x00ccff,0x00e7ff,
			0x00ffff,0x00ffff,0x00ffff,0x00ffb5,0x00ffb6,0x00ffb7,0x84ff00,0x84ff01,0x84ff02,0x84ff03,0xd6ff00,
			0xd6ff00,0xd6ff00,0xffff00,0xffff00,0xffff00,0xffe700,0xffe700,0xffe700,0xffcc00,0xffae00,0xffae00,
			0xffae00,0xff9900,0xff9900,0xff9900,0xff8200,0xff8200,0xff8200,0xff8200,0xff5100,0xff5100,0xff5100,
			0xff0000,0xff0000,0xff0000,0xff4542,0xff4542,0xff4542,0xff4542,0xff6666,0xff6666,0xff6666,0xff8a8c,
			0xff8a8c,0xff8a8c,0xff9999,0xff9999,0xffb6b5,0xffd3d6, 0xffdddd];
		
		private var radius:Number=10;
		private var directionLineHeight:Number=20;
		private var graph:Sprite = new Sprite();
		private var windSpeedSprites:ArrayList = new ArrayList();
		
		public function WeatherWindIcon(temperature:Number, windDegrees:Number, windSpeed:Number)
		{
			var colorIndex:Number = temperature+50;
			if (temperature < -50){
				colorIndex = 0;
			}else if (temperature > 50){
				colorIndex = 100;
			}

			graph.graphics.beginFill(colorRef[colorIndex], 1);
			graph.graphics.drawCircle(0, 0, radius);
			
			if (windSpeed != 0){
				graph.graphics.drawRect(-2, -(radius+directionLineHeight), 4, directionLineHeight);
				var windDirectionIndPosition:Number = -(radius+directionLineHeight);
				
				while (windSpeed >= 5){					
					if (windSpeed >= 10){
						graph.graphics.drawRect(2, windDirectionIndPosition, 10, 3);
						windSpeed -= 10;
					}else if (windSpeed >= 5){
						graph.graphics.drawRect(2, windDirectionIndPosition, 5, 3);						
						windSpeed -= 5;
					}
					windDirectionIndPosition += 4;
				}
				
				graph.rotation = windDegrees;
			}
			this.addChild(graph);
			this.addChild(createTextField(temperature.toString(), radius, radius, -radius / 1.2, -radius / 1.2));
		}
		
		
		
		private function createTextField(label:String, width:Number, height:Number, x:Number=5, y:Number=5):TextField
		{
			var labelMc:TextField=new TextField();
			labelMc.selectable=false;
			labelMc.border=false;
			labelMc.embedFonts=false;
			labelMc.mouseEnabled=false;
			labelMc.width=width;
			labelMc.height=height;
			labelMc.text=label;
			labelMc.autoSize=TextFieldAutoSize.CENTER;
			labelMc.x=x;
			labelMc.y=y;
			labelMc.cacheAsBitmap = true;
			return labelMc;
		}
		
	}
	
}