import Toybox.Graphics;
import Toybox.WatchUi;

class TodaysInsightsView extends WatchUi.View {
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
        
        // Hardcoded values for now
        _userLoc = "Durham, NC";
        _userExposureTime = 360;
        _nextUserReminderTime = 120;
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

        // Icons
        dc.drawBitmap(
            centerX - 115, 
            centerY - 150,
            _locationIcon
        );

        dc.drawBitmap(
            centerX - 150, 
            centerY - 100,
            _exposureIcon
        );

        dc.drawBitmap(
            centerX - 150, 
            centerY - 25,
            _riskIcon
        );

        dc.drawBitmap(
            centerX - 150, 
            centerY + 50,
            _reminderIcon
        );

        dc.drawBitmap(
            centerX - 150, 
            centerY + 125,
            _shadeAlertIcon
        );


        // Text
        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 200, Graphics.FONT_TINY, "Today", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX + 10, centerY - 150, Graphics.FONT_SYSTEM_XTINY, _userLoc, Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}
