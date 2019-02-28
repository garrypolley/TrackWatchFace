using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.StringUtil;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;
using Toybox.Math;

class TrackWatchFaceView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        // Do Nothing and call super
        // Layout is manual anyway
        Ui.WatchFace.onLayout(dc);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Set the base black watchface
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Create Time
        setDefaultAndClear(dc);
        drawTime(dc);

        // Add the date to the top
        setDefaultAndClear(dc);
        drawDate(dc);

        // Draw step info near the top
        setDefaultAndClear(dc);
        drawStepIcon(dc);


        // Add battery icon to watchface
        setDefaultAndClear(dc);
        drawBattery(dc);
    }

    // Helper function to clear the watchface to default colors for text
    function setDefaultAndClear(dc) {
    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    	dc.clear();
    }

    // Helper function to draw the time
    function drawTime(dc) {
    	// Get the current time and format it correctly
        var minuteTimeFormat = "$1$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("Use24HourFormat")) {
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

    // Helper function for drawing step goal
    function drawStepIcon(dc) {
    	var info = ActivityMonitor.getInfo();
    	var steps = info.steps;
    	var stepGoal = info.stepGoal;
    	var stepPercent = steps.toDouble() / stepGoal.toDouble() * 100;
    	var stepGoalsCompleted = Math.ceil(stepPercent / 100);
		print("Goals copmleted");
		print(stepGoalsCompleted);

    	// Draw rectangle location
    	var height = Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY);
    	var offset = 10;
    	var width = (dc.getWidth() / 2) + offset;
    	var x = (dc.getWidth() / 2) + offset; // Add a 1/4 width to both sides of the bar
    	var y = dc.getHeight() / 2;
    	var roundedSize = 10;

    	// Variables for the 'track', goes from right to left to start like you'd run a track
    	var trackStart = dc.getWidth();
    	var trackLaneEnd = width + 2 * offset;
    	var trackStartY = y - height / 2;
    	var trackLaneEndY = y + height / 2;

    	// Draw the base 'track' for the goal to wrap around
    	drawBaseTrack(dc, 3, y, height, trackStart, trackStartY, trackLaneEnd, trackLaneEndY);

    	//---- Begin drawing the watch face based on progress towards the goal -----
    	for( var i = 0; i < stepGoalsCompleted; i++ ) {
			// Setup the Pen for the track
			dc.setColor(getPenColor(i), Graphics.COLOR_TRANSPARENT);
		    dc.setPenWidth(getPenSize(i));
			var trackWdith = trackStart - trackLaneEnd;

		    // 0 - 40 top track
			var reduceAmountForAbove100 = i * 100;
			var normalizedPercent = stepPercent - reduceAmountForAbove100;

			if (normalizedPercent < 40) {
				var topCompleted = normalizedPercent / 40;
		        var trackTopProgressPoint = trackStart - (trackWdith * topCompleted);
				dc.drawLine(trackStart, trackStartY, trackTopProgressPoint, trackStartY);
			} else {
				dc.drawLine(trackStart, trackStartY, trackLaneEnd, trackStartY);
			}

		    // 41 - 60 left arc
			if (normalizedPercent > 40 && normalizedPercent < 60 ) {
				var arcCompleted = normalizedPercent / 60;
				var arcLength = 270 - 90;
				var arcEndPoint = 90 + (arcCompleted * arcLength);
				dc.drawArc(trackLaneEnd, y, height / 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, arcEndPoint);
			} else if (normalizedPercent >= 60) {
				dc.drawArc(trackLaneEnd, y, height / 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, 270);
			}

		    // 61 - 100 bottom track
			if (normalizedPercent > 60) {
				var topCompleted = normalizedPercent / 100;
		        var bottomTrackProgressPoint =  trackLaneEnd + (trackWdith * topCompleted);
				dc.drawLine(trackLaneEnd, trackLaneEndY, bottomTrackProgressPoint, trackLaneEndY);
			}
		}

		// Reset the pen size after the function call
		dc.setPenWidth(1);

    	// Get size of progress goal
    	var progressSize = (width * stepPercent).toNumber();
    	if (progressSize >= width) {
    		progressSize = width;
		}

    	// Draw progress of goal


    	// Draw step text
    	var stepText = formatIntWithComma(steps);

    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    	dc.drawText(
    		trackLaneEnd,
    		y,
        	Graphics.FONT_SYSTEM_XTINY,
        	stepText,
        	(Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT)
    	);
    }

	// Helper function that returns an integer using a comma format.
    function formatIntWithComma(int) {
    	var intAsString = Lang.format("$1$", [int]);
    	var intAsCharArray = intAsString.toCharArray().reverse();
		var returnArray = [];
		var addedCommas = 0;

		for (var i = 0; i < intAsCharArray.size(); i++) {
			var modIshThree = Math.floor(i / 3);

			if (modIshThree > addedCommas) {
				returnArray.add(',');
				addedCommas++;
			}

			returnArray.add(intAsCharArray[i]);
		}

		return StringUtil.charArrayToString(returnArray.reverse());
    }

	function print(value) {
//		Sys.println(value);
	}

    function getPenSize(value) {
    	if (value == 0) {
    		return 3;
    	}
    	if (value == 1) {
    		return 5;
    	}
    	return 7;
    }

	function getPenColor(value) {
		if (value == 0) {
    		return Graphics.COLOR_GREEN;
    	}
    	if (value == 1) {
    		return Graphics.COLOR_DK_GREEN;
    	}
    	return Graphics.COLOR_PURPLE;
	}

    function drawBaseTrack(dc, penWidth, y, height, trackStart, trackStartY, trackLaneEnd, trackLaneEndY) {
    	dc.setPenWidth(penWidth); // Default starting pen width because it looks nice
    	dc.drawLine(trackStart, trackStartY, trackLaneEnd, trackStartY); // top track line
    	dc.drawLine(trackLaneEnd, trackLaneEndY, trackStart, trackLaneEndY);  // bottom track line
    	dc.drawArc(trackLaneEnd, y, height / 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, 270); // curve of track
    }

    function drawBattery(dc) {
    	// Setup the outer white box for the battery indicator
    	var height = 12;
    	var width = 22;
		var offset = 20;
    	var x = (dc.getWidth() / 2) + offset;
    	var y = dc.getHeight() / 2 + (Graphics.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_THAI_HOT) / 2) - height + 3;

    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
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
