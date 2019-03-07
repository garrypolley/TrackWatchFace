using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;


// Helper function to draw the time
function drawTime(dc) {
    // Get the current time and format it correctly
    var minuteTimeFormat = "$1$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;
    if (!System.getDeviceSettings().is24Hour) {
        if (hours > 12) {
            hours = hours - 12;
        }
        // If it's midnight, make it say 12
        if (hours == 0) {
            hours = 12;
        }
    } else {
        if (Application.getApp().getProperty("Use24HourFormat")) {
            hours = hours.format("%02d");
        }
    }

    // Setup the hour time format
    var hourTimeFormat = "$1$";
    if (hours < 10) {
        hourTimeFormat = "0$1$";
    }

    var hoursText = Lang.format(hourTimeFormat, [hours]);
    var minutesText = Lang.format(minuteTimeFormat, [clockTime.min.format("%02d")]);


    // Setup drawing locations
    var x = 1.5 * dc.getTextWidthInPixels("00", Graphics.FONT_SYSTEM_NUMBER_THAI_HOT);
    var heightSpace = 2;
    var hourY = (dc.getHeight() / 2) - dc.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_THAI_HOT) - heightSpace;
    var minuteY = (dc.getHeight() / 2) + heightSpace;

    dc.drawText(
        x,
        hourY,
        Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
        hoursText,
        (Graphics.TEXT_JUSTIFY_RIGHT)
    );

    dc.drawText(
        x,
        minuteY,
        Graphics.FONT_SYSTEM_NUMBER_THAI_HOT,
        minutesText,
        (Graphics.TEXT_JUSTIFY_RIGHT)
    );
}