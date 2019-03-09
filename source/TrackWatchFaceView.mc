using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;


class TrackWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        // Do Nothing and call super
        // Layout is manual anyway
        WatchUi.WatchFace.onLayout(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
		// Setup positional locations
		var xMiddle = dc.getWidth() / 2;
		var yMiddle = dc.getHeight() / 2;
		var offset = 20;
		var iconHeight = 12;
		var iconWidth = 22;
		var trackHeight = Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY);
		var trackOffset = (trackHeight / 2) + 6;
		var aboveTrackItemY = yMiddle - trackOffset;
		var iconY = yMiddle + trackOffset;

        // Set the base black watchface
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Create Time
        setDefaultAndClear(dc);
        drawTime(dc);

        // Add the date to the top
        setDefaultAndClear(dc);
		drawDayMonth(dc, xMiddle + (offset * 2), aboveTrackItemY);
		drawDayOfWeek(dc, xMiddle, Graphics.getFontHeight(Graphics.FONT_SYSTEM_SMALL));

        // Draw step info near the top
        setDefaultAndClear(dc);
        drawStepIcon(dc, xMiddle, yMiddle, trackHeight);

        // Add battery icon to watchface
        setDefaultAndClear(dc);
        drawBattery(dc, xMiddle + offset, iconY, iconHeight, iconWidth, offset);

		setDefaultAndClear(dc);
		drawPhoneIndicator(dc, xMiddle + iconWidth + (offset * 2), iconY + offset);
    }

	function drawPhoneIndicator(dc, x, y) {
		if (System.getDeviceSettings().phoneConnected) {
			System.println("Phone connected");
		} else {
			System.println("no phone connected");
		}

		var points = [
			[x, y],
			[x - 5, y + 6],
			[x - 5.25, y + 6.5],
			[x - 5.5, y + 7],
			[x - 5.25, y + 7.5],
			[x - 5, y + 10],
			[x - 4, y + 11],
			[x - 3, y + 12.5],
			[x - 2.5, y + 13],
			[x - 1.25, y + 15],
			[x, y + 16],
			[x + 1.25, y + 18],
			[x + 5, y + 20],
			[x + 8.75, y + 22.5],
			[x + 12.5, y + 24.5],
			[x + 17, y + 25],
			[x + 20, y + 27],
			[x + 22.5, y + 26],
			[x + 25, y + 24.5],
			[x + 25.5, y + 24],
			[x + 26, y + 23.5],
			[x + 26.5, y + 22.5],

			// [x - 5, y + 27.5],
			[x + 30, y + 27.5],
			[x + 30, y]
		];

		dc.fillPolygon(points);
	}

    // Helper function to clear the watchface to default colors for text
    function setDefaultAndClear(dc) {
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    	dc.clear();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
