import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

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

    // TYPES
    enum {
        HEART,
        STEPS,
        STRESS,
        RESPIRATION,
        CALORIES,
        DISTANCE,
        ACTIVEMINUTES,
        BODYBATTERY,
        MOVE
    }

    private var fields = [
        HEART,
        STEPS,
        STRESS,
        RESPIRATION,
        CALORIES,
        DISTANCE,
        ACTIVEMINUTES,
        BODYBATTERY,
        MOVE
    ];


    function initialize() {
        var dictionary = {
            :identifier => "Gauges"
        };
        iconsFont = WatchUi.loadResource(Rez.Fonts.IcoFont);

        Drawable.initialize(dictionary);
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

    function getIcon(key) as String {
        switch (key) {
            case HEART:
                return 60447.toChar().toString();
            case STEPS:
                return 61239.toChar().toString();
            case STRESS:
                return 60426.toChar().toString();
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
            case MOVE:
                return 60973.toChar().toString();
            default:
                return "";
            }
    }

    function drawStressLvl(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var arcStart = 0;
        var arcLength = 60;
        var HRThickness = Math.floor((thickness + padding) / 4);

        var stressLvl = getStressLvl();
        if (stressLvl != null) {
            var stressColor = Application.Properties.getValue("TenderGreen");

            if (stressLvl > 75) {
                stressColor = Application.Properties.getValue("WarmRed");
            } else if (stressLvl > 50) {
                stressColor = Application.Properties.getValue("EdgyPurple");
            }

            dc.setColor(stressColor, Graphics.COLOR_BLACK);

            var stressStepsCount = Math.ceil((innerRadius - padding) / HRThickness);
            var j = 0;

            while (j < stressStepsCount) {
                if (stressLvl >= j * 100 / stressStepsCount) {
                    dc.drawArc(outerRadius, outerRadius, 44 + j * HRThickness, Graphics.ARC_CLOCKWISE, arcStart - 3 * arcLength, arcStart - 4 * arcLength);
                }
                j++;
            }
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(Math.PI * 7 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 7 / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(Math.PI * 7 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 7 / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(STRESS),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawMoveBar(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var arcStart = 0;
        var arcLength = 60;

        var max = ActivityMonitor.MOVE_BAR_LEVEL_MAX;
        var info = ActivityMonitor.getInfo();
        var moveLvl = info.moveBarLevel;
        
        dc.setAntiAlias(true);

        for (var i = 0; i < max; i++) {
            dc.setPenWidth(thickness);
            if (moveLvl == null) {
                dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
                dc.drawArc(outerRadius, outerRadius, 44 + padding / 4 + i * thickness / 2, Graphics.ARC_CLOCKWISE, arcStart, arcStart - arcLength);
            } else {
                dc.setColor(colors[i], Graphics.COLOR_TRANSPARENT);
                
                if (i < moveLvl as Number) {
                  dc.drawArc(outerRadius, outerRadius, 44 + padding / 4 + i * thickness / 2, Graphics.ARC_CLOCKWISE, arcStart, arcStart - arcLength);
                }
            }
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(Math.PI * 1 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 1 / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(Math.PI * 1 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 1 / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(MOVE),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawHR(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var arcStart = 0;
        var arcLength = 60;

        var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        var heartRate = getHeartRate();
        var zone = getHeartRateZone();
        var HRMax = zones[5];
        var HRMin = zones[0];
        var HRThickness = Math.floor((thickness + padding) / 4);
        var HRStepsCount = Math.ceil((innerRadius - padding) / HRThickness);
        var HRIncrement = HRMax / HRStepsCount;

        dc.setPenWidth(HRThickness.toNumber() + 2);
        dc.setColor(colors[zone], Graphics.COLOR_TRANSPARENT);
        var i = 0;
        while (i < HRStepsCount) {
            if (heartRate >= i * HRIncrement) {
                dc.drawArc(outerRadius, outerRadius, 44 + i * HRThickness, Graphics.ARC_CLOCKWISE, arcStart - arcLength, arcStart - 2 * arcLength);
            }
            i++;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(Math.PI / 2) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI / 2) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(Math.PI / 2) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI / 2) * (outerRadius - 44),
            iconsFont,
            getIcon(HEART),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawSteps(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var HRThickness = Math.floor((thickness + padding) / 4);
        var arcStart = 0;
        var arcLength = 60;
        
        var stepPercent = getSteps();
        var stepStepsCount = Math.ceil((innerRadius - padding) / HRThickness);
        if (stepPercent >= 1.0) {
            dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Application.Properties.getValue("DeepBlue"), Graphics.COLOR_TRANSPARENT);
        }

        var j = 0;

        while (j < stepStepsCount) {
            if (stepPercent >= (j * 1.0 / stepStepsCount)) {
                dc.drawArc(outerRadius, outerRadius, 44 + j * HRThickness, Graphics.ARC_CLOCKWISE, arcStart - 2 * arcLength, arcStart - 3 * arcLength);
            }
            j++;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(Math.PI * 5 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 5 / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(Math.PI * 5 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 5 / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(STEPS),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawBodyBattery(dc as Dc) as Void {
        var bodyBattery = getBodyBattery();

        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius - 44;
        var thickness = (innerRadius / 5).toNumber();
        var padding = thickness;
        var arcStart = 0;
        var arcLength = 60;
        var HRThickness = Math.floor((thickness + padding) / 4);

        dc.setColor(Application.Properties.getValue("GoldenYellow"), Graphics.COLOR_BLACK);

        var bodyBatteryStepsCount = Math.ceil((innerRadius - padding) / HRThickness);
        var j = 0;

        while (j < bodyBatteryStepsCount) {
            if (bodyBattery >= j * 100 / bodyBatteryStepsCount) {
                dc.drawArc(outerRadius, outerRadius, 44 + j * HRThickness, Graphics.ARC_CLOCKWISE, arcStart - 5 * arcLength, arcStart - 6 * arcLength);
            }
            j++;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(
            outerRadius + Math.cos(Math.PI * 11 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 11 / 6) * (outerRadius - 44),
            14
        );    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            outerRadius + Math.cos(Math.PI * 11 / 6) * (outerRadius - 44),
            outerRadius + Math.sin(Math.PI * 11 / 6) * (outerRadius - 44),
            iconsFont,
            getIcon(BODYBATTERY),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
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

    function draw(dc as Dc) as Void {
        drawMoveBar(dc);
        drawHR(dc);
        drawSteps(dc);
        drawStressLvl(dc);
        drawBodyBattery(dc);
        drawGrid(dc);
    }
}