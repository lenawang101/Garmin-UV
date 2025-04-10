import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Math;

class TimestampComparator {
    public function compare(a as Object, b as Object) as Number {
        // Safely cast each object to Dictionary
        var ad = a as Dictionary;
        var bd = b as Dictionary;
        if (ad == null or bd == null) {
            return 0; // If something unexpected, treat as equal
        }

        // We expect :timestamp to be a Number
        var at = ad[:timestamp] as Number?;
        var bt = bd[:timestamp] as Number?;
        if (at == null or bt == null) {
            return 0;
        }

        // Subtract them so that smaller timestamps come first
        return at - bt;
    }
}

class GraphInsightsView extends WatchUi.View {
    // Mock values
    private var _userLoc;
    private var _userExposureTime;
    private var _nextUserReminderTime;

    private var _locationIcon;
    private var _exposureIcon;
    private var _riskIcon;
    private var _reminderIcon;
    private var _shadeAlertIcon;
    
    // Colors
    private var _bgColor = 0xAA9E9E; // Light gray/beige background
    private var _circleColor = 0x336699; // Blue circle
    private var _textColor = 0xFFFFFF; // White text
    
    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        // Set background color
        dc.setColor(_bgColor, _bgColor);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        
        // Calculate circle dimensions
        var circleRadius = width * 0.8;
        
        // Draw main blue circle
        dc.setColor(_circleColor, _circleColor);
        dc.fillCircle(centerX, centerY, circleRadius);
        var storedUvReadings = Storage.getValue("uvReadings") as Array<Dictionary>;


        // if (storedUvReadings == null || storedUvReadings.size() == 0) {
        //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        //     dc.drawText(centerX, centerY, Graphics.FONT_SMALL, "No UV readings found", Graphics.TEXT_JUSTIFY_CENTER);
        // }
        
        // iterator for just UV readings from the last minute
        var currentTime = Time.now().value();
        var oneMinAgo = currentTime - 60; // 1 minute in seconds
        var filteredReadings = [] as Array<Dictionary>;

        for (var i = 0; i < storedUvReadings.size(); i++) {
            var entry = storedUvReadings[i];
            // System.println("Filtered Entry:" + entry);
            // Check dictionary keys with hasKey(:key)
            var ts = entry["timestamp"];
            var uvVal = entry["uv"];
            if (ts != null and uvVal != null) {
                // Only take readings from the last minute
                if (ts >= oneMinAgo) {
                    // System.println("Filtered Entry:" + entry);
                    filteredReadings.add(entry);
                }
            }
        }

        if (filteredReadings.size() == 0) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, centerY, Graphics.FONT_SMALL, "No recent data", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        var comparator = new TimestampComparator();
        filteredReadings.sort(comparator);
        System.println("FILTERED READINGS: " + filteredReadings);


// CODE TO PRINT LAST 7 UV VALUES
        

        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // var yPos = centerY - 150;
        // var lineHeight = dc.getFontHeight(Graphics.FONT_TINY) + 3;

        // // Calculate how many lines can fit before running off screen:
        // // We'll leave ~10px margin at the bottom
        // var maxVisibleLines = ((height - 10) - yPos) / lineHeight;

        // var totalLines = filteredReadings.size();
        // var startIndex = 0;
        // if (totalLines > maxVisibleLines) {
        //     startIndex = totalLines - maxVisibleLines.toNumber();
        // }

        // // Draw each line from startIndex .. end
        // for (var i = startIndex; i < totalLines; i++) {
        //     var uvVal = filteredReadings[i]["uv"];
        //     var tsVal = filteredReadings[i]["timestamp"];
        //     var lineStr = "UV=" + uvVal.toString() + " @ " + tsVal.toString();
        //     dc.drawText(centerX, yPos, Graphics.FONT_TINY, lineStr, Graphics.TEXT_JUSTIFY_CENTER);
        //     yPos += lineHeight;
        // }
        
// CODE ENDS HERE

        var xStart = 10; // Starting position for the X axis
        var yStart = 250; // Starting position for the Y axis
        var xSpacing = 30; // Space betweenn each data point on the X axis
        var maxUvValue = 15; // Assuming the UV values range from 0 to 15, adjust as necessary

        var i = 0; // Counter for horizontal positioning of the graph
        var j = 0; // Counter for index of filteredReadings
        var sample = filteredReadings[j];


        // while (sample != null && j < filteredReadings.size()) {
        while (sample != null && j < 12) {
            // Get the next sample
            sample = filteredReadings[j];
            // var uvVal = Toybox.Math.rand() % 9;
            // System.println("rand num " + uvVal);
            var uvVal = sample["uv"]; // Get the UV value from the sample

            // Calculate the y-coordinate based on the UV value
            var ratio = uvVal.toFloat() / maxUvValue.toFloat();
            var uvHeight = -ratio * 120; // Scale the UV value to fit the graph height

            var newX = xStart + xSpacing;

            // Draw the UV chart (bar graph)
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(xStart, yStart, xSpacing, uvHeight);

            xStart = newX;
            // yStart = newY;
           
            i++; // Move to the next position on the X axis
            j++;
             
        }

        WatchUi.requestUpdate(); // Request an update to the UI
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        // Any setup needed when showing the view
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        

    }

}