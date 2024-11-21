import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Time extends WatchUi.Drawable {
    private var bebasNumbersFont;
    private var bebasNumbersLgFont;

    function initialize() {
        var dictionary = {
            :identifier => "Time"
        };
        bebasNumbersFont = WatchUi.loadResource(Rez.Fonts.BebasNeueNumbersFont);
        bebasNumbersLgFont = WatchUi.loadResource(Rez.Fonts.BebasNeueNumbersLgFont);
        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        var isLg = false;
        if (dc.getWidth() > 400) {
            isLg = true;
        }

        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var mins = clockTime.min.format("%02d");
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        
        dc.setAntiAlias(true);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x - 1,
            y - (isLg == true ? 20 : 15),
            isLg == true ? bebasNumbersLgFont : bebasNumbersFont,
            hours.format("%02d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        dc.drawText(
            x - 1,
            y + (isLg == true ? 20 : 15),
            isLg == true ? bebasNumbersLgFont : bebasNumbersFont,
            mins,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

}