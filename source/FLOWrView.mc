import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Time;
import Toybox.Time.Gregorian;

class FLOWrView extends WatchUi.WatchFace {
    private var ring;
    private var weather;
    var lastKnownPosition = null;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        ring = View.findDrawableById("Ring");
        weather = View.findDrawableById("WeatherField");
        if (ring != null) {
            ring.setWatch(self);
        }
        if (weather != null) {
            weather.setWatch(self);
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function isPositionValid(position) {
        if (position == null) {
            return false;
        }

        if (position.toDegrees()[0] == 0 || Math.round(position.toDegrees()[0]) == 180) {
            return false;
        }

        if (position.toDegrees()[1] == 0 || Math.round(position.toDegrees()[1]) == 180) {
            return false;
        }

        return true;
    }

    function getAndStorePosition() as Boolean {
        var currentPositionInfo = Position.getInfo();
        if (isPositionValid(currentPositionInfo.position)) {
            var currentPosition = currentPositionInfo.position;
            storePositionInfo(currentPosition);
        } else {
            var currentActivityInfo = Activity.getActivityInfo();
            var currentLocation = currentActivityInfo.currentLocation;
            if (isPositionValid(currentLocation)) {
                storePositionInfo(currentLocation);
            } else {
                var weatherCurrentConditions = Weather.getCurrentConditions();
                if (weatherCurrentConditions != null && weatherCurrentConditions.observationLocationPosition != null) {
                    var currentWeatherLocation= weatherCurrentConditions.observationLocationPosition;
                    storePositionInfo(currentWeatherLocation);
                } else {
                    var lastPositionLat = retrievePersistedValue("last-position-lat");
                    var lastPositionLng = retrievePersistedValue("last-position-lng");
                    if (lastPositionLat != null && lastPositionLng != null) {
                        var lastPosition = new Toybox.Position.Location({ :latitude => lastPositionLat, :longitude => lastPositionLng, :format => :degrees });
                        storePositionInfo(lastPosition);
                    }
                }
            }
        }

        return lastKnownPosition != null;
    }

    function storePositionInfo(position as Position.Location) as Void {
        lastKnownPosition = position;
        persistValue("last-position-lng", position.toDegrees()[1].toFloat());
        persistValue("last-position-lat", position.toDegrees()[0].toFloat());
        WatchUi.requestUpdate();
    }

    function onStart(state as Dictionary) as Void {
        getAndStorePosition();
    }

    function persistValue(key as String, value) as Void {
        if ( Application has :Storage ) {
            Application.Storage.setValue(key, value);
        } else {
            Application.getApp().setProperty(key, value);
        }
    }

    function retrievePersistedValue(key as String) {
        if ( Application has :Storage ) {
            Application.Storage.getValue(key);
        } else {
            Application.getApp().getProperty(key);
        }
    }

    function clearPersistedValue(key as String) as Void {
        if ( Application has :Storage ) {
            Application.Storage.deleteValue(key);
        } else {
            Application.getApp().deleteProperty(key);
        }
    }
}
