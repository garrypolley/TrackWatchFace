using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

// Helper function to draw date
function drawDayMonth(dc, x, y) {
    var dateFormat = "$1$ $2$";
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

    var dateString = Lang.format(dateFormat, [today.day, today.month]);

    dc.drawText(
        x,
        y - (Graphics.getFontHeight(Graphics.FONT_SYSTEM_SMALL) / 3),
        Graphics.FONT_SYSTEM_SMALL,
        dateString,
        (Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER)
    );
}

function drawDayOfWeek(dc, x, y) {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var dateString = "";

    switch (today.day_of_week) {
        case 1:
            dateString = "Sunday";
            break;
        case 2:
            dateString = "Monday";
            break;
        case 3:
            dateString = "Tuesday";
            break;
        case 4:
            dateString = "Wednesday";
            break;
        case 5:
            dateString = "Thursday";
            break;
        case 6:
            dateString = "Friday";
            break;
        case 7:
            dateString = "Saturday";
            break;
    }

    dc.drawText(
        x,
        y,
        Graphics.FONT_SYSTEM_SMALL,
        dateString,
        (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER)
    );
}