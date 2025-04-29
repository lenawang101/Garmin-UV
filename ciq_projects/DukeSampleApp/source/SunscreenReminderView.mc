import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Application.Storage;

class SunscreenReminderView extends WatchUi.View {

    // Colors
    private var _bgColor = 0xB1720C; // Orange background
    private var _circleColor = 0x7C421F; // Dark orange circle
    private var _textColor = 0xFFFFFF; // White text

    // icons
    private var _sunAlarm;
    //! Constructor
    //! TOOD: Add @param uvDataModel The model containing the UV data
    public function initialize() {
        View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _sunAlarm = WatchUi.loadResource(Rez.Drawables.SunscreenAlarm);
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
        
        // Draw main orange circle
        dc.setColor(_circleColor, _circleColor);
        dc.fillCircle(centerX, centerY, circleRadius);

        // Draw shade alert icon
        dc.drawBitmap(centerX - 25, centerY - 165, _sunAlarm);
        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 80, Graphics.FONT_SMALL, "Sunscreen Reminder", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 20, Graphics.FONT_XTINY, "Reapply", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 50, Graphics.FONT_XTINY, "appropriate SPF", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 80, Graphics.FONT_XTINY, "every 2-3 hours", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 110, Graphics.FONT_XTINY, "during prolonged", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 140, Graphics.FONT_XTINY, "exposure time.", Graphics.TEXT_JUSTIFY_CENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}
