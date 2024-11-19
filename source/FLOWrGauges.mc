import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;

class Gauges extends WatchUi.Drawable {
    private var steps = 1.0 as Float;
    private var colors = [
        Application.Properties.getValue("BrightBlue"),
        Application.Properties.getValue("DeepBlue"),
        Application.Properties.getValue("EdgyPurple"),
        Application.Properties.getValue("GoldenYellow"),
        Application.Properties.getValue("WarmRed"),
    ];
    private var iconsFont;
    private var weatherFont;
    private var sourceSansProSmallFont;

    private var dIcons = {
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

    private var nIcons = {
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

    private var units; 
    private var watch;    


    // TYPES
    enum {
        HEART,
        BATTERY,
        STEPS,
        STRESS,
        RESPIRATION,
        CALORIES,
        DISTANCE,
        ACTIVEMINUTES,
        WEATHER,
        BODYBATTERY,
        MOVE,
    }

    private var fields = [
        HEART,
        BATTERY,
        STEPS,
        STRESS,
        RESPIRATION,
        CALORIES,
        DISTANCE,
        ACTIVEMINUTES,
        WEATHER,
        BODYBATTERY,
        MOVE,
    ];

    function setWatch(watchView as WatchUi.View) as Void {
        watch = watchView;
    }

    function initialize() {
        var dictionary = {
            :identifier => "Gauges"
        };
        units = Application.Properties.getValue("units") == 0 || System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC ? "metric" : "imperial";
        iconsFont = WatchUi.loadResource(Rez.Fonts.IcoFont);
        weatherFont = WatchUi.loadResource(Rez.Fonts.IcoWeatherFont);
        sourceSansProSmallFont = WatchUi.loadResource(Rez.Fonts.SourceSansProFont);
        
        Drawable.initialize(dictionary);
    }

    function getBatteryIcon() {
        var battery = Math.floor(System.getSystemStats().battery);

        var batteryIconCharNumber;
        if (battery < 25) {
            batteryIconCharNumber = 61108;
        } else if (battery < 50) {
            batteryIconCharNumber = 61107;
        } else {
            batteryIconCharNumber = 61106;
        }

        return batteryIconCharNumber.toChar().toString();
    }

    function getIcon(key) as String {
        switch (key) {
        case HEART:
            return 60447.toChar().toString();
        case STEPS:
            return 61239.toChar().toString();
        case STRESS:
            return 60426.toChar().toString();
        case BATTERY:
            return getBatteryIcon();
        case RESPIRATION: 
            return 61315.toChar().toString();
        case CALORIES: 
            return 61226.toChar().toString();
        case DISTANCE: 
            return 60860.toChar().toString();
        case ACTIVEMINUTES: 
            return 61234.toChar().toString();  
        case BODYBATTERY:
            return 60247.toChar().toString();
        default:
            return "";
        }
    }

    function getValue(type) as Number {
        var value = 0;
        var info = ActivityMonitor.getInfo();
        
        switch (type) {
            case HEART:
                value = getHeartRate();
                break;
            case STEPS:
                value = getSteps();
                break;
            case STRESS:
                value = getStressLvl();
                break;
            case BATTERY:
                value = Math.floor(System.getSystemStats().battery);
                break;
            case RESPIRATION:
                value = info.respirationRate;
                break;
            case CALORIES:
                value = info.calories;
                break;
            case DISTANCE:
                value = info.distance;
                break;
            case ACTIVEMINUTES:
                value = info.activeMinutesDay.total;
                break;
            case BODYBATTERY:
                value = getBodyBattery();
                break;
            }   

        return value;
    }

    function getColor(type, value) {
        var color = Graphics.COLOR_WHITE;

        switch (type) {
            case HEART:
                var zone = getHeartRateZone();
                color = colors[zone];
                break;
            case STEPS:
                if (value >= 1.0) {
                    color = Application.Properties.getValue("TenderGreen");
                } else {
                    color = Application.Properties.getValue("DeepBlue");
                }
                break;
            case STRESS:
                color = Application.Properties.getValue("TenderGreen");
                if (value > 75) {
                    color = Application.Properties.getValue("WarmRed");
                } else if (value > 50) {
                color = Application.Properties.getValue("EdgyPurple");
            }
                break;
            case BATTERY:
                if (value < 25) {
                    color = Application.Properties.getValue("WarmRed");
                } else if (value < 50) {
                    color = Application.Properties.getValue("GoldenYellow");
                } else {
                    color = Application.Properties.getValue("TenderGreen");
                }
                break;
            case RESPIRATION:
                color = Application.Properties.getValue("DeepBlue");
                break;
            case CALORIES:
                color = Application.Properties.getValue("GoldenYellow");
                break;
            case DISTANCE:
                color = Application.Properties.getValue("BrightBlue");
                break;
            case ACTIVEMINUTES:
                color = Application.Properties.getValue("WarmRed");
                break;
            case BODYBATTERY:
                color = Application.Properties.getValue("GoldenYellow");
                break;
            }   

        return color;
    }

    function getHeartRate() {
        var activityInfo = Activity.getActivityInfo();
        var sample = activityInfo.currentHeartRate;
        var value = 1.0;
        if (sample != null) {
            value = sample;
        } else if (ActivityMonitor has :getHeartRateHistory) {
          sample = ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true)
            .next();
            if ((sample != null) && (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE)) {
                value = sample.heartRate;
            }
        }

        return value;
    }

    function getHeartRateZone() {
        var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        var sample = getHeartRate();

        if (sample < zones[0]) {
            return 0;
        } else if (sample < zones[1]) {
            return 1;
        } else if (sample < zones[2]) {
            return 2;
        } else if (sample < zones[3]) {
            return 3;
        }
        return 4;
    }

    function getRawSteps() as Void {
        var info = ActivityMonitor.getInfo();
        if (info.steps != null && info.steps > 0) {
            steps = info.steps.toFloat();
        } 
    }

    function getSteps() as Float {
        getRawSteps();
        var info = ActivityMonitor.getInfo();
        var goal = info.stepGoal.toFloat();

        if (goal == null) {
            return steps * 0.02;
        }

        var stepsToGoalRatio = steps / goal;
        if (stepsToGoalRatio >= 1) {
            return 1.0;
        }

        return stepsToGoalRatio;
    }

    function getBodyBattery() as Float {
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            var sample = SensorHistory.getBodyBatteryHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST }).next();

            if (sample != null) {
                return sample.data;
            }
        }

        return 1.0;
    }

    function getStressLvl() {
        var sample = null;
        var value = null;

        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
            sample = SensorHistory.getStressHistory({:period => 1})
            .next();

            if (sample != null && sample.data != null) {
                value = sample.data;
            }
        }

        return value;
    }

    function drawGrid(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawLine(22, outerRadius, dc.getWidth() - 22, outerRadius);
        dc.drawLine(outerRadius, outerRadius, outerRadius + Math.cos(Math.PI / 3) * (outerRadius - 22), outerRadius + Math.sin(Math.PI / 3) * (outerRadius - 22));
        dc.drawLine(outerRadius, outerRadius, outerRadius + Math.cos(2 * Math.PI / 3) * (outerRadius - 22), outerRadius + Math.sin(2 * Math.PI / 3) * (outerRadius - 22));
        dc.drawLine(outerRadius, outerRadius, outerRadius + Math.cos(4 * Math.PI / 3) * (outerRadius - 22), outerRadius + Math.sin(4 * Math.PI / 3) * (outerRadius - 22));
        dc.drawLine(outerRadius, outerRadius, outerRadius + Math.cos(5 * Math.PI / 3) * (outerRadius - 22), outerRadius + Math.sin(5 * Math.PI / 3) * (outerRadius - 22));
    }

    function getWeather() as Number {
        var conditions = Weather.getCurrentConditions();
        if (conditions != null) {
        return conditions.condition;
        }

        return Weather.CONDITION_UNKNOWN;
    }

    function getWeatherIcon(condition as Number, dayOrNite as Boolean) as String {
        var icon = dayOrNite ? dIcons[condition] : nIcons[condition];

        if (icon == null) {
        return "";
        }

        return icon.toChar().toString();
    }

    function getPressureTrend() as String {
        var value = "";
        var pressure = null;
        var previousMeanPressure = null;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
        var history = SensorHistory.getPressureHistory({ :period => 10, :order => SensorHistory.ORDER_NEWEST_FIRST });
        var sample = history.next();
        if ((sample != null) && (sample.data != null)) {
            pressure = sample.data;
            previousMeanPressure = sample.data;
        }
        sample = history.next();
        var i = 0;
        while ((sample != null) && (sample.data != null) && i < 10) {
            previousMeanPressure = (previousMeanPressure + sample.data) / 2;
            sample = history.next();
            i++;
        } 

        if (pressure > previousMeanPressure) {
            value = "↗";
        } else if (pressure < previousMeanPressure) {
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

    function drawWeather(dc as Dc, propertyKey as String) as Void {
        var width = dc.getWidth();
        var outerRadius = width / 2;
        var offset = getRadianOffset(propertyKey);
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(offset + Math.PI / 6) * (44 + 16),
            outerRadius + Math.sin(offset + Math.PI / 6) * (44 + 16),
            weatherFont,
            getWeatherIcon(getWeather(), getDayOrNite()),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            outerRadius + Math.cos(offset + Math.PI / 6) * (outerRadius - 44),
            outerRadius + Math.sin(offset + Math.PI / 6) * (outerRadius - 44 + 12),
            sourceSansProSmallFont,
            getTemperature() + getPressureTrend(),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );  
    }

    function getRadianOffset(propertyKey as String) as Float {
        var offset = 0.0;
        switch (propertyKey) {
            case "topLeftMetric": 
                offset = -3 * Math.PI / 3;
                break;
            case "topMetric": 
                offset = -2 * Math.PI / 3;
                break;
            case "topRightMetric": 
                offset = -1 * Math.PI / 3;
                break;
            case "bottomLeftMetric": 
                offset = -4 * Math.PI / 3;
                break;
            case "bottomMetric": 
                offset = -5 * Math.PI / 3;
                break;
            case "bottomRightMetric": 
                offset = -6 * Math.PI / 3;
                break;
        }

        return offset;
    }

    function getArcOffset(propertyKey as String) as Number {
        var arcOffset = 0;
        var arcLength = 60;

        switch (propertyKey) {
            case "topLeftMetric": arcOffset = 3 * arcLength;
                break;
            case "topMetric": arcOffset = 4 * arcLength;
                break;
            case "topRightMetric": arcOffset = 5 * arcLength;
                break;
            case "bottomLeftMetric": arcOffset = 2 * arcLength;
                break;
            case "bottomMetric": arcOffset = arcLength;
                break;
            case "bottomRightMetric": arcOffset = 0;
        }

        return arcOffset;
    }


    function drawMoveBar(dc as Dc, propertyKey as String) as Void {
        var offset = getRadianOffset(propertyKey);
        var arcOffset = getArcOffset(propertyKey);

        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var arcStart = 0;
        var arcLength = 60;

        var max = ActivityMonitor.MOVE_BAR_LEVEL_MAX;
        var info = ActivityMonitor.getInfo();
        var moveLvl = info.moveBarLevel;

        for (var i = 0; i < max; i++) {
            dc.setPenWidth(thickness);
            if (moveLvl == null) {
                dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
                dc.drawArc(outerRadius, outerRadius, 44 + padding / 4 + i * thickness / 2, Graphics.ARC_CLOCKWISE, arcStart - arcOffset, arcStart - arcOffset - arcLength);
            } else {
                dc.setColor(colors[i], Graphics.COLOR_TRANSPARENT);
                
                if (i < moveLvl as Number) {
                  dc.drawArc(outerRadius, outerRadius, 44 + padding / 4 + i * thickness / 2, Graphics.ARC_CLOCKWISE, arcStart - arcOffset, arcStart - arcOffset - arcLength);
                }
            }
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(offset + Math.PI / 6) * (outerRadius - 44),
            outerRadius + Math.sin(offset + Math.PI / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(offset + Math.PI / 6) * (outerRadius - 44),
            outerRadius + Math.sin(offset + Math.PI / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(MOVE),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawGauge(dc as Dc, field as Number, propertyKey as String) as Void {
        var value = getValue(field);
        var offset = getRadianOffset(propertyKey);
        var arcOffset = getArcOffset(propertyKey);
        var color = getColor(field, value);

        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var gaugeIncrementThickness = Math.floor((thickness + padding) / 4);
        var arcStart = 0;
        var arcLength = 60;
        var gaugeStepsCount = Math.ceil((innerRadius - padding) / gaugeIncrementThickness);
        var maxValue = field == STEPS ? 1.0 : 100.0;
        
        if (value == null) {
            return;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var j = 0;
        while (j < gaugeStepsCount) {
            if (value >= (j * maxValue / gaugeStepsCount)) {
                dc.drawArc(outerRadius, outerRadius, 44 + j * gaugeIncrementThickness, Graphics.ARC_CLOCKWISE, arcStart - arcOffset, arcStart - arcOffset - arcLength);
            }
            j++;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(offset + Math.PI / 6) * (outerRadius - 44),
            outerRadius + Math.sin(offset + Math.PI / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(offset + Math.PI / 6) * (outerRadius - 44),
            outerRadius + Math.sin(offset + Math.PI / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(field),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawField(dc as Dc, propertyKey as String) as Void {
        var fieldIdx = Application.Properties.getValue(propertyKey);
        var field = fields[fieldIdx];

        if (field == WEATHER) {
            drawWeather(dc, propertyKey);
        } else if (field == MOVE) {
            drawMoveBar(dc, propertyKey);
        } else {
            drawGauge(dc, field, propertyKey);
        }
    }

    function draw(dc as Dc) as Void {
        dc.setAntiAlias(true);

        drawField(dc, "topLeftMetric");
        drawField(dc, "topMetric");
        drawField(dc, "topRightMetric");
        drawField(dc, "bottomLeftMetric");
        drawField(dc, "bottomMetric");
        drawField(dc, "bottomRightMetric");
        
        drawGrid(dc);
    }
}