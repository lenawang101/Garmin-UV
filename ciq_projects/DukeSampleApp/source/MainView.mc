import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
import Toybox.Application.Storage;

// Venu 3 has 390x390 pixel dims
// RUN WITH 3S MODEL

// (:background)
class MainView extends WatchUi.View {
    private var _deviceDataModel as DeviceDataModel;

    // We'll default these, then update them from BLE
    private var _uvIndex;
    private var _uvStatus;

    // (Your existing arcs, icons, colors, etc.)
    private var _sunIcon;

    private var _leftDefaultArc;
    private var _topLeftDefaultArc;
    private var _topDefaultArc;
    private var _topRightDefaultArc;
    private var _rightDefaultArc;

    private var _leftColorArc;
    private var _topLeftColorArc;
    private var _topColorArc;
    private var _topRightColorArc;
    private var _rightColorArc;

    private var _leftArc;
    private var _topLeftArc;
    private var _topArc;
    private var _topRightArc;
    private var _rightArc;

    private var _bgColor = 0xAA9E9E;
    private var _circleColor = 0x336699;
    private var _textColor = 0xFFFFFF;
    private var _accumulatedUv;

    //! Modified constructor
    public function initialize(deviceDataModel as DeviceDataModel) {
        View.initialize();
        _deviceDataModel = deviceDataModel;

        // Start with some default or placeholder
        _uvIndex = 0;
        _uvStatus = "Low";
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        // Icon imports from Figma
        _sunIcon = WatchUi.loadResource(Rez.Drawables.Sun);

        _leftDefaultArc = WatchUi.loadResource(Rez.Drawables.LeftDefault);
        _topLeftDefaultArc = WatchUi.loadResource(Rez.Drawables.TopLeftDefault);
        _topDefaultArc = WatchUi.loadResource(Rez.Drawables.TopDefault);
        _topRightDefaultArc = WatchUi.loadResource(Rez.Drawables.TopRightDefault);
        _rightDefaultArc = WatchUi.loadResource(Rez.Drawables.RightDefault);
        
        _leftColorArc = WatchUi.loadResource(Rez.Drawables.LeftColor);
        _topLeftColorArc = WatchUi.loadResource(Rez.Drawables.TopLeftColor);
        _topColorArc = WatchUi.loadResource(Rez.Drawables.TopColor);
        _topRightColorArc = WatchUi.loadResource(Rez.Drawables.TopRightColor);
        _rightColorArc = WatchUi.loadResource(Rez.Drawables.RightColor);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        // Any setup needed when showing the view
        // Every time the MainView is shown, pull the stored UV readings
        // var storedUvReadings = Storage.getValue("uvReadings");
        // _accumulatedUv = 0;
        // if (storedUvReadings != null) {
        //     for (var i = 0; i < storedUvReadings.size(); i++) {
        //         var entry = storedUvReadings[i];
        //         if (entry has :uv) {
        //             _accumulatedUv += entry[:uv].toNumber();
        //         }
        //     }
        // }
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        _leftArc = _leftDefaultArc;
        _topLeftArc = _topLeftDefaultArc;
        _topArc = _topDefaultArc;
        _topRightArc = _topRightDefaultArc;
        _rightArc = _rightDefaultArc;
        // 1) Pull real-time UV from BLE if connected
        var isConnected = _deviceDataModel.isConnected();
        if (isConnected) {
            var profile = _deviceDataModel.getActiveProfile();
            if (profile != null) {
                var customData = profile.getCustomDataByteArray();
                System.println("customData: " + customData);
                if (customData != null && customData.size() > 0) {
                    // Single byte for UV reading
                    var uvVal = customData[0].toNumber();
                    _uvIndex = uvVal;


                    if (uvVal <= 2) {
                        _uvStatus = "Low";
                        _leftArc = _leftColorArc;
                    } else if (uvVal <= 5) {
                        _uvStatus = "Moderate";
                        _topLeftArc = _topLeftColorArc;
                    } else if (uvVal <= 7) {
                        _uvStatus = "High";
                        _topArc = _topColorArc;
                    } else if (uvVal <= 10) {
                        _uvStatus = "Very High";
                        _topRightArc = _topRightColorArc;
                    } else {
                        _uvStatus = "Extremely High";
                        _rightArc = _rightColorArc;
                    } 
                }
            }
        }
        // 2) Now draw everything just like before
        dc.setColor(_bgColor, _bgColor);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        var circleRadius = width * 0.8;

        dc.setColor(_circleColor, _circleColor);
        dc.fillCircle(centerX, centerY, circleRadius);

        // Sun icon
        dc.drawBitmap(centerX - 25, centerY - 165, _sunIcon);

        // Arcs, etc...
        dc.drawBitmap(centerX - 190, centerY - 65, _leftArc);
        dc.drawBitmap(centerX - 160, centerY - 160, _topLeftArc);
        dc.drawBitmap(centerX - 62, centerY - 182, _topArc);
        dc.drawBitmap(centerX + 90, centerY - 160, _topRightArc);
        dc.drawBitmap(centerX + 165, centerY - 65, _rightArc);
        

        // Use the updated _uvIndex and _uvStatus here:
        dc.setColor(_textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX - 10, centerY - 130, Graphics.FONT_NUMBER_THAI_HOT, _uvIndex.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 50, Graphics.FONT_SMALL, "Current UV Index", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 100, Graphics.FONT_TINY, _uvStatus, Graphics.TEXT_JUSTIFY_CENTER);

        // Draw the sum of stored UV readings
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    public function onHide() as Void {
        // Any cleanup needed when hiding the view
    }
}