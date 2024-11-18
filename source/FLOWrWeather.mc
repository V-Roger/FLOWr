import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;

class WeatherField extends WatchUi.Drawable {
  private var sourceSansProSmallFont;
  private var weatherFont;
  private var dIcons;
  private var nIcons;
  private var watch;
  private var units; 

  function initialize() {
    var dictionary = {
      :identifier => "WeatherField"
    };

    units = Application.Properties.getValue("units") == 0 || System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC ? "metric" : "imperial";

    sourceSansProSmallFont = Graphics.FONT_TINY;
    weatherFont = WatchUi.loadResource(Rez.Fonts.IcoWeatherFont);

    dIcons = {
      Weather.CONDITION_CLEAR => 61054,
      Weather.CONDITION_PARTLY_CLOUDY =>  61016,
      Weather.CONDITION_MOSTLY_CLOUDY =>  61059,
      Weather.CONDITION_RAIN =>  61034,
      Weather.CONDITION_SNOW =>  61035,
      Weather.CONDITION_WINDY =>  61080,
      Weather.CONDITION_THUNDERSTORMS =>  61033,
      Weather.CONDITION_WINTRY_MIX =>  61020,
      Weather.CONDITION_FOG =>  61065,
      Weather.CONDITION_HAZY =>  61065,
      Weather.CONDITION_HAIL =>  61025,
      Weather.CONDITION_SCATTERED_SHOWERS =>  61032,
      Weather.CONDITION_SCATTERED_THUNDERSTORMS =>  61023,
      Weather.CONDITION_UNKNOWN_PRECIPITATION =>  61043,
      Weather.CONDITION_LIGHT_RAIN =>  61054,
      Weather.CONDITION_HEAVY_RAIN =>  61032,
      Weather.CONDITION_LIGHT_SNOW =>  61053,
      Weather.CONDITION_HEAVY_SNOW =>  61035,
      Weather.CONDITION_LIGHT_RAIN_SNOW =>  61045,
      Weather.CONDITION_HEAVY_RAIN_SNOW =>  61039,
      Weather.CONDITION_CLOUDY =>  61009,
      Weather.CONDITION_RAIN_SNOW =>  61043,
      Weather.CONDITION_PARTLY_CLEAR =>  61010,
      Weather.CONDITION_MOSTLY_CLEAR =>  61016,
      Weather.CONDITION_LIGHT_SHOWERS =>  61054,
      Weather.CONDITION_SHOWERS =>  61032,
      Weather.CONDITION_HEAVY_SHOWERS =>  61034,
      Weather.CONDITION_CHANCE_OF_THUNDERSTORMS =>  61060,
      Weather.CONDITION_MIST =>  61065,
      Weather.CONDITION_DRIZZLE =>  61045,
      Weather.CONDITION_TORNADO =>  61061,
      Weather.CONDITION_HAZE =>  61065,
      Weather.CONDITION_FAIR =>  61054,
      Weather.CONDITION_HURRICANE =>  61061,
      Weather.CONDITION_TROPICAL_STORM =>  61061,
      Weather.CONDITION_UNKNOWN =>  61027,
      Weather.CONDITION_DUST =>  61065,
      Weather.CONDITION_SMOKE =>  61065,
      Weather.CONDITION_VOLCANIC_ASH =>  61064,
      Weather.CONDITION_FLURRIES =>  61039,
      Weather.CONDITION_FREEZING_RAIN =>  61037,
      Weather.CONDITION_SLEET =>  61043,
      Weather.CONDITION_THIN_CLOUDS =>  61010,
      Weather.CONDITION_ICE_SNOW =>  61039,
      Weather.CONDITION_ICE =>  61037,
      Weather.CONDITION_SQUALL =>  61080,
      Weather.CONDITION_CHANCE_OF_SHOWERS =>  61032,
      Weather.CONDITION_CHANCE_OF_SNOW =>  61044,
      Weather.CONDITION_CHANCE_OF_RAIN_SNOW =>  61045,
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN =>  61032,
      Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW =>  61046,
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW =>  61045,
    };

    nIcons = {
      Weather.CONDITION_CLEAR => 61030,
      Weather.CONDITION_PARTLY_CLOUDY =>  61015,
      Weather.CONDITION_MOSTLY_CLOUDY =>  61059,
      Weather.CONDITION_RAIN =>  61034,
      Weather.CONDITION_SNOW =>  61035,
      Weather.CONDITION_WINDY =>  61080,
      Weather.CONDITION_THUNDERSTORMS =>  61033,
      Weather.CONDITION_WINTRY_MIX =>  61020,
      Weather.CONDITION_FOG =>  61065,
      Weather.CONDITION_HAZY =>  61065,
      Weather.CONDITION_HAIL =>  61025,
      Weather.CONDITION_SCATTERED_SHOWERS =>  61031,
      Weather.CONDITION_SCATTERED_THUNDERSTORMS =>  61022,
      Weather.CONDITION_UNKNOWN_PRECIPITATION =>  61043,
      Weather.CONDITION_LIGHT_RAIN =>  61030,
      Weather.CONDITION_HEAVY_RAIN =>  61031,
      Weather.CONDITION_LIGHT_SNOW =>  61053,
      Weather.CONDITION_HEAVY_SNOW =>  61035,
      Weather.CONDITION_LIGHT_RAIN_SNOW =>  61044,
      Weather.CONDITION_HEAVY_RAIN_SNOW =>  61039,
      Weather.CONDITION_CLOUDY =>  61009,
      Weather.CONDITION_RAIN_SNOW =>  61043,
      Weather.CONDITION_PARTLY_CLEAR =>  61010,
      Weather.CONDITION_MOSTLY_CLEAR =>  61015,
      Weather.CONDITION_LIGHT_SHOWERS =>  61030,
      Weather.CONDITION_SHOWERS =>  61031,
      Weather.CONDITION_HEAVY_SHOWERS =>  61034,
      Weather.CONDITION_CHANCE_OF_THUNDERSTORMS =>  61060,
      Weather.CONDITION_MIST =>  61065,
      Weather.CONDITION_DRIZZLE =>  61041,
      Weather.CONDITION_TORNADO =>  61061,
      Weather.CONDITION_HAZE =>  61065,
      Weather.CONDITION_FAIR =>  61030,
      Weather.CONDITION_HURRICANE =>  61061,
      Weather.CONDITION_TROPICAL_STORM =>  61061,
      Weather.CONDITION_UNKNOWN =>  61026,
      Weather.CONDITION_DUST =>  61065,
      Weather.CONDITION_SMOKE =>  61065,
      Weather.CONDITION_VOLCANIC_ASH =>  61064,
      Weather.CONDITION_FLURRIES =>  61039,
      Weather.CONDITION_FREEZING_RAIN =>  61037,
      Weather.CONDITION_SLEET =>  61043,
      Weather.CONDITION_THIN_CLOUDS =>  61010,
      Weather.CONDITION_ICE_SNOW =>  61039,
      Weather.CONDITION_ICE =>  61037,
      Weather.CONDITION_SQUALL =>  61080,
      Weather.CONDITION_CHANCE_OF_SHOWERS =>  61031,
      Weather.CONDITION_CHANCE_OF_SNOW =>  61040,
      Weather.CONDITION_CHANCE_OF_RAIN_SNOW =>  61041,
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN =>  61031,
      Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW =>  61042,
      Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW =>  61041,
    };

    Drawable.initialize(dictionary);
  }

  function setWatch(watchView as WatchUi.View) as Void {
    watch = watchView;
  }

  function getWeather() as Number {
    var conditions = Weather.getCurrentConditions();
    if (conditions != null) {
      return conditions.condition;
    }

    return Weather.CONDITION_UNKNOWN;
  }

  function getWindSpeed() as String {
    var conditions = Weather.getCurrentConditions();
    if (conditions != null) {
      return (conditions.windSpeed * (units.equals("metric") ? 3.6 : 2.23694)).format("%.1f");
    }

    return "";
  }

  function drawWindIndicator(dc as Dc) as Void {
    var conditions = Weather.getCurrentConditions();
    if (conditions != null) {
      var bearing = conditions.windBearing;
      var x = 65;
      var y = dc.getHeight() / 2 - 65;

      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon([[x + Math.sin((bearing + 90) / 57.2958) * 8, y + Math.cos((bearing + 90) / 57.2958) * 8 ],[x + Math.sin(bearing / 57.2958) * 20, y + Math.cos(bearing / 57.2958) * 20], [x + Math.sin((bearing - 90) / 57.2958) * 8, y + Math.cos((bearing - 90) / 57.2958) * 8] ]);
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.fillCircle(x, y, 12);
    }
  }

  function getWeatherIcon(condition as Number, dayOrNite as Boolean) as String {
    var icon = dayOrNite ? dIcons[condition] : nIcons[condition];

    if (icon == null) {
      return "";
    }

    return icon.toChar().toString();
  }

  function getPressure() as String {
    var value = "";
    var pressure = null;

    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
      var sample = SensorHistory.getPressureHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST }).next();
      if ((sample != null) && (sample.data != null)) {
        pressure = sample.data;
      }
    }

    if (pressure != null) {
      pressure = pressure / 100; // Pa --> mbar;
      value = (pressure.format("%.1f") + (units.equals("metric") ? "hPa " : "mbar ")); 
    }

    return value + getPressureTrend();
  }

  function getPressureTrend() as String {
    var value = "";
    var pressure = null;
    var previousPressure = null;

    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
      var history = SensorHistory.getPressureHistory({ :period => 2, :order => SensorHistory.ORDER_NEWEST_FIRST });
      var sample = history.next();
      if ((sample != null) && (sample.data != null)) {
        pressure = sample.data;
        previousPressure = sample.data;
      }
      sample = history.next();
      if ((sample != null) && (sample.data != null)) {
        previousPressure = sample.data;
      }

      if (pressure > previousPressure) {
        value = "↗";
      } else if (pressure < previousPressure) {
        value = "↘";
      } else {
        value = "→";
      }
    }

    return value;
  }

  function getTemperature() as String {
    var conditions = Weather.getCurrentConditions();
    if (conditions != null) {
      if (units.equals("metric")) {
        return conditions.temperature.format("%d") + "°C";
      } else {
        return (conditions.temperature  * (9.0 / 5) + 32).format("%d") + "°F";
      }
    }

    return "?!";
  }

  function getDayOrNite() as Boolean {
    var now = Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
    var today = Gregorian.moment({ :year => now.year, :month => now.month, :day => now.day, :hour => 0 });
    var fallback = now.hour <= 21 && now.hour >= 6;
    
    if (watch.lastKnownPosition == null) {
      return fallback;
    }

    var sunrise = Weather.getSunrise(watch.lastKnownPosition, today); 
    var sunset = Weather.getSunset(watch.lastKnownPosition, today);
    var momentNow = new Time.Moment(Time.now().value());

    if (sunrise == null || sunset == null) {
      return fallback;
    }

    return momentNow.lessThan(sunset) && momentNow.greaterThan(sunrise);
  }

  function getAltitude() as String {
    var activityInfo = Activity.getActivityInfo();
    var altitude = activityInfo.altitude;
    var value = "";
    
    if ((altitude == null) && (Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
      var sample = SensorHistory.getElevationHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST })
        .next();
      if ((sample != null) && (sample.data != null)) {
        altitude = sample.data;
      }
    }
    if (altitude != null) {
      value = units.equals("metric") ? altitude.format("%d") + "m" : (altitude * 3.28084).format("%d") + "ft";
    }

    return value;
  }

  function draw(dc as Dc) as Void {
    // var height = dc.getHeight();
    var width = dc.getWidth();
    var outerRadius = width / 2;
  
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
        outerRadius + Math.cos(Math.PI * 3 / 2) * (outerRadius - 44),
        outerRadius + Math.sin(Math.PI * 3 / 2) * (outerRadius - 44),
        weatherFont,
        getWeatherIcon(getWeather(), getDayOrNite()),
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );

    // drawWindIndicator(dc);
    // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    // dc.drawText(
    //   75,
    //   height / 2 - 65,
    //   sourceSansProSmallFont,
    //   getWindSpeed(),
    //   Graphics.TEXT_JUSTIFY_RIGHT| Graphics.TEXT_JUSTIFY_VCENTER
    // );

    // dc.drawText(
    //     outerRadius + Math.cos(Math.PI * 3 / 2) * (outerRadius - 44),
    //     outerRadius + Math.sin(Math.PI * 3 / 2) * (outerRadius - 44),
    //     sourceSansProSmallFont,
    //     getTemperature(),
    //     Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    // );

    // dc.drawText(
    //   width / 2 + 5,
    //   height / 2 - 70,
    //   sourceSansProSmallFont,
    //   getAltitude(),
    //   Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    // );

    // dc.drawText(
    //   width / 2 + 5,
    //   height / 2 - 55,
    //   sourceSansProSmallFont,
    //   getPressure(),
    //   Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
    // );
  }

}