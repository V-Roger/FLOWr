import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Activity;

class Ring extends WatchUi.Drawable {
    private var sunrise = null;
    private var sunset = null;
    private var utcSunrise = null;
    private var utcSunset = null;
    private var now = Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
    private var today = Gregorian.moment({ :year => now.year, :month => now.month, :day => now.day, :hour => 0 });
    private var watch;

    function initialize() {
        var dictionary = {
            :identifier => "Ring"
        };
        Drawable.initialize(dictionary);
    }

    function setWatch(watchView as WatchUi.View) as Void {
      watch = watchView;
    }

    function getSunriseSunset() {
      var sunriseSunsetSetAt = watch.retrievePersistedValue("sunriseSunsetSetAt");

      if (watch.lastKnownPosition != null) {
        if (sunriseSunsetSetAt == null || sunriseSunsetSetAt.toNumber() < Time.now().subtract(new Time.Duration(24 * 60 * 60)).value()) {
          watch.clearPersistedValue("sunrise");
          watch.clearPersistedValue("sunset");
          watch.clearPersistedValue("sunriseSunsetSetAt");

          sunrise = Weather.getSunrise(watch.lastKnownPosition, today); 
          sunset = Weather.getSunset(watch.lastKnownPosition, today);

          if (sunrise != null && sunset != null) {
            watch.persistValue("sunrise", sunrise.value());
            watch.persistValue("sunset", sunset.value());
            watch.persistValue("sunriseSunsetSetAt", Time.now().value());
          }
        } else {
          var sunriseValue = watch.retrievePersistedValue("sunrise").toNumber();
          var sunsetValue = watch.retrievePersistedValue("sunset").toNumber();

          if (sunriseValue != null && sunsetValue != null) {
            sunrise = new Time.Moment(sunriseValue);
            sunset = new Time.Moment(sunriseValue);
          }
        }
      } else {
        watch.getAndStorePosition();
        return false;
      }

      return sunrise != null && sunset != null;
    }

    function drawRing(dc as Dc) {
      var outerRadius = dc.getWidth() / 2;
      var innerRadius = outerRadius * 0.88;
      var colors = [];
      var arcIncrement = Math.floor(360 / 24);

      if (sunrise == null || sunset == null) {
        var success = getSunriseSunset();

        if (!success) { 
          return false;
        }
      }
  
      if (sunrise != null && sunset != null) {
        utcSunrise = Gregorian.utcInfo(sunrise, Time.FORMAT_SHORT);
        utcSunset = Gregorian.utcInfo(sunset, Time.FORMAT_SHORT);
        for (var i = 0; i < 24; i++) {
          if (
            i <= utcSunrise.hour - 2 || i >= utcSunset.hour + 2
          ) {
            colors.add(0x091D38);
          } else if (
            i <= utcSunrise.hour - 1 || i >= utcSunset.hour + 1
          ) {
            colors.add(0x216ED1);
          } else if (
            i <= utcSunrise.hour || i >= utcSunset.hour
          ) {
            colors.add(0xEB6F42);
          } else if (
            i <= utcSunrise.hour + 2 || i >= utcSunset.hour - 2
          ) {
            colors.add(0xF68347);
          } else {
            colors.add(0xF6D647);
          }
        }
      }

      dc.setAntiAlias(true);
      dc.setPenWidth((outerRadius * 0.08).toNumber());
      
      for (var i = 0; i < colors.size(); i++) {
        var start = -90 + (i * arcIncrement);
        var end = start + arcIncrement;
        dc.setColor(colors.reverse()[i], Graphics.COLOR_TRANSPARENT);
        dc.drawArc(outerRadius, outerRadius, outerRadius, Graphics.ARC_COUNTER_CLOCKWISE, start, end);
      }
      var step = Math.floor(360 / 12);
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      for (var i = 0; i < 12; i++) {
        dc.fillCircle(outerRadius + Math.cos((180 + (i - 1) * step) / 57.2958) * (innerRadius - 2), outerRadius + Math.sin((180 + (i - 1) * step) / 57.2958) * (innerRadius - 2), 1.5);
      }
      
      if (utcSunrise != null) {
        dc.setColor(0xD9663D, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([
          [
            outerRadius + (Math.cos((92 + ((utcSunrise.hour + 1+ utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
            outerRadius + (Math.sin((92 + ((utcSunrise.hour + 1 + utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
          ],
          [
            outerRadius + (Math.cos((88 + ((utcSunrise.hour + 1 + utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
            outerRadius + (Math.sin((88 + ((utcSunrise.hour + 1 + utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
          ],
          [
            outerRadius + (Math.cos((90 + ((utcSunrise.hour + 1 + utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 1),
            outerRadius + (Math.sin((90 + ((utcSunrise.hour + 1 + utcSunrise.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 1),
          ],
        ]);
      } 
            
      if (utcSunset != null) {
        dc.setColor(0x216ED1, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([
          [
            outerRadius + (Math.cos((92 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
            outerRadius + (Math.sin((92 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
          ],
          [
            outerRadius + (Math.cos((88 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
            outerRadius + (Math.sin((88 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (outerRadius + 1),
          ],
          [
            outerRadius + (Math.cos((90 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 1),
            outerRadius + (Math.sin((90 + ((utcSunset.hour + 1 + utcSunset.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 1),
          ],
        ]);
      }

      var clockTime = System.getClockTime();
      if (clockTime.hour <= utcSunrise.hour || clockTime.hour >= utcSunset.hour) {
        dc.setColor(0x216ED1, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(0xD9663D, Graphics.COLOR_TRANSPARENT);
      }

      dc.fillCircle(
        outerRadius + (Math.cos((90 + ((clockTime.hour + 1 + clockTime.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 2),
        outerRadius + (Math.sin((90 + ((clockTime.hour + 1 + clockTime.min / 60)) * arcIncrement) / 57.2958)) * (innerRadius - 2),
        4
      );

      return true;
    }

    function draw(dc as Dc) as Void {
        drawRing(dc);
    }
}