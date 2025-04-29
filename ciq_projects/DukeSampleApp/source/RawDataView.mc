import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Storage;

class RawDataView extends WatchUi.View {

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

        // WatchUi.requestUpdate(); // Request an update to the UI
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
        

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var yPos = centerY - 150;
        var lineHeight = dc.getFontHeight(Graphics.FONT_TINY) + 3;

        // Calculate how many lines can fit before running off screen:
        // We'll leave ~10px margin at the bottom
        var maxVisibleLines = ((height - 10) - yPos) / lineHeight;

        var totalLines = filteredReadings.size();
        var startIndex = 0;
        if (totalLines > maxVisibleLines) {
            startIndex = totalLines - maxVisibleLines.toNumber();
        }

        // Draw each line from startIndex .. end
        for (var i = startIndex; i < totalLines; i++) {
            var uvVal = filteredReadings[i]["uv"];
            var tsVal = filteredReadings[i]["timestamp"];
            var lineStr = "UV=" + uvVal.toString() + " @ " + tsVal.toString();
            dc.drawText(centerX, yPos, Graphics.FONT_TINY, lineStr, Graphics.TEXT_JUSTIFY_CENTER);
            yPos += lineHeight;
        }

    }

}