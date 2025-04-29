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
    
    // Colors
    private var _bgColor = 0xAA9E9E; // Light gray/beige background
    private var _circleColor = 0x336699; // Blue circle
    private var _textColor = 0xFFFFFF; // White text

    private var _currentPage;
    private var _firstPage;
    private var _lastPage;
    
    var _uvColor = Graphics.COLOR_BLUE; 

    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _currentPage = WatchUi.loadResource(Rez.Drawables.CurrentToggle);
        _firstPage = WatchUi.loadResource(Rez.Drawables.NextToggle);
        _lastPage = WatchUi.loadResource(Rez.Drawables.NextToggle);
        // Set background color
        dc.setColor(_bgColor, _bgColor);
        dc.clear();
        
        var startSeconds = 0;
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // Calculate circle dimensions
        var circleRadius = width * 0.8;


        
        // Draw main blue circle
        dc.setColor(_circleColor, _circleColor);
        dc.fillCircle(centerX, centerY, circleRadius);
        var storedUvReadings;
        if (Storage.getValue("uvReadings") == null) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(centerX, centerY, Graphics.FONT_SMALL, "No UV readings found", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        storedUvReadings = Storage.getValue("uvReadings") as Array<Dictionary>;
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
            dc.drawText(centerX, centerY - 50, Graphics.FONT_SYSTEM_SMALL, "Exposure Over Time", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        else {
            var comparator = new TimestampComparator();
            filteredReadings.sort(comparator);
            System.println("FILTERED READINGS: " + filteredReadings);

            var xStart = 40; // Starting position for the X axis
            var yStart = 250; // Starting position for the Y axis
            var xSpacing = 24; // Space betweenn each data point on the X axis
            var maxUvValue = 15; // Assuming the UV values range from 0 to 15, adjust as necessary

            var i = 0; // Counter for horizontal positioning of the graph
            var j = 0; // Counter for index of filteredReadings
            var sample = filteredReadings[j];

            // while (sample != null && j < filteredReadings.size()) {
            // Depending on j value, need to check if sample is null, if we can access the data, and if its within the last 12 values
            while ((sample != null) && (j < filteredReadings.size()) && (j < 12)) {
                // Get the next sample
                sample = filteredReadings[j];
                // var randNum = Toybox.Math.rand() % 9;
                // System.println("rand num " + uvVal);
                var uvVal = sample["uv"]; // Get the UV value from the sample

                // Calculate the y-coordinate based on the UV value
                var ratio = uvVal.toFloat() / maxUvValue.toFloat();
                var uvHeight = -ratio * 150; // Scale the UV value to fit the graph height

                var newX = xStart + xSpacing;

                // Draw the UV chart (bar graph)
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(centerX, centerY - 105, Graphics.FONT_SYSTEM_XTINY, "Exposure (Prev 60 mins)", Graphics.TEXT_JUSTIFY_CENTER);
                
                switch (uvVal) {
                    case 0:
                    case 1:
                        _uvColor = 0x00FF00; // Green
                        break;
                    case 2:
                    case 3:
                    case 4:
                        _uvColor = 0xD7BB66; // Yellow
                        break;
                    case 5:
                    case 6:
                        _uvColor = 0xF28612; // Orange
                        break;
                    case 7:
                    case 8:
                        _uvColor = 0xE7371B; // Red
                        break;
                    case 9:
                    case 10:
                        _uvColor = 0x800080; // Purple
                        break;
                    case 11:
                    default:
                        _uvColor = Graphics.COLOR_BLUE; // Default color if unexpected value
                        break;
                }
                
                dc.setColor(_uvColor, Graphics.COLOR_TRANSPARENT);
                dc.drawRectangle(xStart, yStart, xSpacing, uvHeight);

                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(xStart + 12, yStart - 115, Graphics.FONT_SYSTEM_XTINY, uvVal, Graphics.TEXT_JUSTIFY_CENTER);
                dc.drawText(centerX, centerY + 30, Graphics.FONT_SYSTEM_XTINY, "__________________________", Graphics.TEXT_JUSTIFY_CENTER);

                xStart = newX;
                // yStart = newY;
            
                i++; // Move to the next position on the X axis
                j++;
                startSeconds += 1;
            }
            dc.drawBitmap(centerX - 170, centerY - 30, _firstPage);
            dc.drawBitmap(centerX - 170, centerY - 10, _lastPage);
            dc.drawBitmap(centerX - 170, centerY + 10, _currentPage);
            WatchUi.requestUpdate(); // Request an update to the UI
        }

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