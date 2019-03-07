using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

// Helper function to draw date
function drawDate(dc) {
    var dateFormat = "$1$ $2$, $3$";
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

    var dateString = Lang.format(dateFormat, [today.day_of_week, today.day, today.month]);

    // Setup drawing
    var x = dc.getWidth() / 2;
    var y = Graphics.getFontHeight(Graphics.FONT_SYSTEM_SMALL);

    dc.drawText(
        x,
        y,
        Graphics.FONT_SYSTEM_SMALL,
        dateString,
        (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER)
    );
}