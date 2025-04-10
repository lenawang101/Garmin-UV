import Toybox.Lang;
import Toybox.WatchUi;

class MainDelegate extends WatchUi.BehaviorDelegate {
    private var _viewController as ViewController;
    private var _deviceDataModel as DeviceDataModel;
    private var _mainView as MainView;

    public function initialize(viewController as ViewController, deviceDataModel as DeviceDataModel, mainView as MainView) {
        BehaviorDelegate.initialize();
        _viewController = viewController;
        _deviceDataModel = deviceDataModel;
        _mainView = mainView;
    }

    //! If the user taps anywhere, go to the Insights screen (same as before)
    public function onTap(clickEvent as ClickEvent) as Boolean {
        _viewController.pushInsightsView();
        return true;
    }

    //! Handle back button - unpair the device
    public function onBack() as Boolean {
        // _deviceDataModel.unpair();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
