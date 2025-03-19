import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;

// Venu 3 has 390x390 pixel dims
// RUN WITH 3S MODEL

class MainView extends WatchUi.View {
    // Mock UV index and status
    private var _uvIndex;
    private var _uvStatus;

    private var _sunIcon;
    private var _leftArc;
    private var _topLeftArc;
    private var _topArc;
    private var _topRightArc;
    private var _rightArc;
    
    // Colors
    private var _bgColor = 0xAA9E9E; // Light gray/beige background
    private var _circleColor = 0x336699; // Blue circle
    private var _textColor = 0xFFFFFF; // White text
    
    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
        
        // Hardcoded values for now
        _uvIndex = 4;
        _uvStatus = "Moderate";
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _sunIcon = WatchUi.loadResource(Rez.Drawables.Sun);
        _leftArc = WatchUi.loadResource(Rez.Drawables.LeftCurve);
        _topLeftArc = WatchUi.loadResource(Rez.Drawables.TopLeftCurve);
        _topArc = WatchUi.loadResource(Rez.Drawables.TopCurve);
        _topRightArc = WatchUi.loadResource(Rez.Drawables.TopRightCurve);
        _rightArc = WatchUi.loadResource(Rez.Drawables.RightCurve);
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

        // Sun icon has a bit of a center displacement
        dc.drawBitmap(
            centerX - 25, 
            centerY - 165,
            _sunIcon
        );

        // Arcs
        dc.drawBitmap(
            centerX - 200, 
            centerY - 65,
            _leftArc
        );

        dc.drawBitmap(
            centerX - 185, 
            centerY - 185,
            _topLeftArc
        );

        dc.drawBitmap(
            centerX - 85, 
            centerY - 215,
            _topArc
        );

        dc.drawBitmap(
            centerX + 100, 
            centerY - 185,
            _topRightArc
        );

        dc.drawBitmap(
            centerX + 185, 
            centerY - 75,
            _rightArc
        );

        // Text
        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX - 10, centerY - 130, Graphics.FONT_NUMBER_THAI_HOT, _uvIndex.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 50, Graphics.FONT_SMALL, "Current UV Index", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 100, Graphics.FONT_TINY, _uvStatus, Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}