
using Toybox.ActivityMonitor;
using Toybox.Graphics;
using Toybox.StringUtil;
using Toybox.Lang;
using Toybox.Math;

// Helper function for drawing step goal
function drawStepIcon(dc, desiredX, desiredY, height) {
    var info = ActivityMonitor.getInfo();
    var steps = info.steps;
    var stepGoal = info.stepGoal;
    var stepPercent = steps.toDouble() / stepGoal.toDouble() * 100;
    var stepGoalsCompleted = Math.ceil(stepPercent / 100);

    // Draw rectangle location
    var offset = 10;
    var width = (dc.getWidth() / 2) + offset;
    var x = (desiredX) + offset; // Add a 1/4 width to both sides of the bar
    var y = desiredY;
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

function drawBaseTrack(dc, penWidth, y, height, trackStart, trackStartY, trackLaneEnd, trackLaneEndY) {
    dc.setPenWidth(penWidth); // Default starting pen width because it looks nice
    dc.drawLine(trackStart, trackStartY, trackLaneEnd, trackStartY); // top track line
    dc.drawLine(trackLaneEnd, trackLaneEndY, trackStart, trackLaneEndY);  // bottom track line
    dc.drawArc(trackLaneEnd, y, height / 2, Graphics.ARC_COUNTER_CLOCKWISE, 90, 270); // curve of track
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