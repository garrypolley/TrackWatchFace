using Toybox.Graphics;
using Toybox.System;

function drawBattery(dc, x, y, height, width, offset) {

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    // Draw the battery casing
    dc.drawRectangle(
        x,
        y,
        width,
        height
    );

    // Draw a tiny little 'power nob' at the end of the battery
    dc.fillRectangle(
        x + width,
        y + height / 4,
        3,
        height / 2
    );

    // Indicate the battery level by color
    var batteryPercentAsNumber = (System.getSystemStats().battery / 5).toNumber();
    var batteryColor;
    if (batteryPercentAsNumber >= 6) {
        batteryColor = Graphics.COLOR_GREEN;
    } else if (batteryPercentAsNumber >= 3) {
        batteryPercentAsNumber = 5; // Make it so you can actually read the battery at a lower level
        batteryColor = Graphics.COLOR_YELLOW;
    } else if (batteryPercentAsNumber >= 2) {
        batteryPercentAsNumber = 4; // Make it so you can actually read the battery at a lower level
        batteryColor = Graphics.COLOR_RED;
    } else {
        // Allow the battery to be super small and hard to read to indicate it's super low
        batteryColor = Graphics.COLOR_RED;
    }

    // Draw battery level
    dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(
        x + 1,
        y + 1,
        batteryPercentAsNumber,
        height - 2
    );
}