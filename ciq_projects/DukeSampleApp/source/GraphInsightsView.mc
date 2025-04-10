import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Storage;

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


        if (storedUvReadings == null || storedUvReadings.size() == 0) {
            System.println("No UV readings available.");
            return;
        }
        
        // iterator for just UV readings from the last minute
        var currentTime = Time.now().value();
        var filteredReadings = [] as Lang.Array<Lang.Dictionary>;
        var oneMinAgo = currentTime - 60; // 1 min ago in seconds

        for (var i = 0; i < storedUvReadings.size(); i++) {
            var entry = storedUvReadings[i];

            //THIS CHUNK OF CODE MAKES IT CRASH
            // if (entry["timestamp"] >= oneMinAgo) {
            //     filteredReadings.add(entry);
            // }
            // CHUNK ENDS HERE
        }

        // var xStart = 10; // Starting position for the X axis
        // var yStart = 100; // Starting position for the Y axis
        // var xSpacing = 20; // Space between each data point on the X axis
        // var maxUvValue = 10; // Assuming the UV values range from 0 to 10, adjust as necessary

        // // Create an iterator for the filtered readings
        // var iterator = filteredReadings.iterator();
        // var sample = iterator.next();
        // var i = 0; // Counter for horizontal positioning of the graph

        // while (sample != null) {
        //     var uvVal = sample["uv"]; // Get the UV value from the sample

        //     // Calculate the y-coordinate based on the UV value
        //     var uvHeight = yStart - (uvVal / maxUvValue) * 50; // Scale the UV value to fit the graph height

        //     // Draw the UV chart (line graph)
        //     dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        //     dc.drawLine(xStart + i * xSpacing, yStart, xStart + (i + 1) * xSpacing, uvHeight);

        //     sample = iterator.next(); // Get the next sample
        //     i++; // Move to the next position on the X axis
        // }

        // WatchUi.requestUpdate(); // Request an update to the UI

        
        // var sample=iterator.next();
        // var i=0;

        // // Draw the uv chart
        // while(sample!=null) {//! null check
        //     if (sample.heartRate!=ActivityMonitor.INVALID_HR_SAMPLE && previous.heartRate!=ActivityMonitor.INVALID_HR_SAMPLE) { //! check for invalid samples
        //         if (sample.heartRate!=0) {
        //             hrOrd=10; //! Height in pixel of current HR in chart / -2 to substract 2px of the frame line
        //             dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_TRANSPARENT);
        //             dc.drawLine(xStartHr-i,yStartHr-hrOrd,xStartHr-i,yStartHr); //! Draw chart if with have a HR value
        //         }
        //     }
        //     sample = iterator.next(); //! Get the next sample
        //     i+=1; //! shift to the next px of the chart
        // }

    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}
