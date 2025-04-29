import Toybox.Graphics;
import Toybox.WatchUi;

class TodaysInsightsView extends WatchUi.View {
    // Mock values
    private var _userLoc;

    private var _locationIcon;
    private var _exposureIcon;
    private var _riskIcon;
    private var _reminderIcon;
    private var _shadeAlertIcon;
    
    // Colors
    private var _bgColor = 0xAA9E9E; // Light gray/beige background
    private var _circleColor = 0x336699; // Blue circle
    private var _textColor = 0xFFFFFF; // White text

    private var _currentPage;
    private var _prevPage;
    private var _nextPage;

    private var _startTime;
    private var _reminderSeconds = 4800;
    
    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
        
        // Hardcoded values for now
        _userLoc = "Durham, NC";
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _locationIcon = WatchUi.loadResource(Rez.Drawables.Location);
        _exposureIcon = WatchUi.loadResource(Rez.Drawables.Exposure);
        _riskIcon = WatchUi.loadResource(Rez.Drawables.Risk);
        _reminderIcon = WatchUi.loadResource(Rez.Drawables.Reminder);
        _shadeAlertIcon = WatchUi.loadResource(Rez.Drawables.ShadeAlert);


        _currentPage = WatchUi.loadResource(Rez.Drawables.CurrentToggle);
        _prevPage = WatchUi.loadResource(Rez.Drawables.NextToggle);
        _nextPage = WatchUi.loadResource(Rez.Drawables.NextToggle);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        // Any setup needed when showing the view
        _startTime = System.getClockTime();
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

        var clock  = System.getClockTime();
        var secondsElapsed = (clock.hour * 3600) + (clock.min * 60) + clock.sec;
        var startSeconds = (_startTime.hour * 3600) + (_startTime.min * 60) + _startTime.sec;
        var totalSeconds = secondsElapsed - startSeconds;

        var reminderCountdown = _reminderSeconds - totalSeconds;
        if (reminderCountdown < 0) { reminderCountdown = 0; }

        
        // Draw main blue circle
        dc.setColor(_circleColor, _circleColor);
        dc.fillCircle(centerX, centerY, circleRadius);

        // Icons
        dc.drawBitmap(
            centerX - 115, 
            centerY - 140,
            _locationIcon
        );

        dc.drawBitmap(
            centerX - 150, 
            centerY - 95,
            _exposureIcon
        );

        dc.drawBitmap(
            centerX - 145, 
            centerY - 30,
            _riskIcon
        );

        dc.drawBitmap(
            centerX - 145, 
            centerY + 35,
            _reminderIcon
        );

        dc.drawBitmap(
            centerX - 145, 
            centerY + 90,
            _shadeAlertIcon
        );


        // Text
        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 180, Graphics.FONT_SYSTEM_XTINY, "Today", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX + 10, centerY - 140, Graphics.FONT_SYSTEM_XTINY, _userLoc, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY - 95, Graphics.FONT_SYSTEM_XTINY, "Total Exposure", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX - 5, centerY - 70, Graphics.FONT_AUX3, totalSeconds + " seconds", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX - 38, centerY - 25, Graphics.FONT_SYSTEM_XTINY, "Low Risk", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX + 30, centerY + 35, Graphics.FONT_SYSTEM_XTINY, "Sunscreen Reminder", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX - 5, centerY + 60, Graphics.FONT_SYSTEM_XTINY, reminderCountdown + " sec left", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX - 26, centerY + 98, Graphics.FONT_SYSTEM_XTINY, "1 Shade Alert", Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawBitmap(centerX - 170, centerY - 30, _prevPage);
        dc.drawBitmap(centerX - 170, centerY - 10, _currentPage);
        dc.drawBitmap(centerX - 170, centerY + 10, _nextPage);
        

    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}
