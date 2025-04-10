import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Storage;

class ShadeAlertNotificationView extends WatchUi.View {

    // Colors
    private var _bgColor = 0xAA9E9E; // Light gray/beige background
    private var _circleColor = 0x336699; // Blue circle
    private var _textColor = 0xFFFFFF; // White text

    // icons
    private var _shadeAlertIcon;
    
    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _shadeAlertIcon = WatchUi.loadResource(Rez.Drawables.ShadeAlertHouse);
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

        // Draw shade alert icon
        dc.drawBitmap(centerX - 25, centerY - 165, _shadeAlertIcon);
        dc.drawText(centerX, centerY - 80, Graphics.FONT_SMALL, "Shade Alert", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 20, Graphics.FONT_TINY, "Take breaks in the shade during extended outdoor time.", Graphics.TEXT_JUSTIFY_CENTER);

    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}
