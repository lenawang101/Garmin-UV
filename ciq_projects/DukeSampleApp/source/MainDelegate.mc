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

    // If the user swipes up, go to the Insights screen
    public function onSwipe(swipeEvent as SwipeEvent) as Boolean {
        System.println("Swipe direction: " + swipeEvent.getDirection());
        if (swipeEvent.getDirection() == 0){
            _viewController.pushInsightsView();
            return true;
        }
        if (swipeEvent.getDirection() == 2) {
            _viewController.pushSunscreenReminder();
            return true;
        }
        return false;
    }

    //! Handle back button - unpair the device
    public function onBack() as Boolean {
        _deviceDataModel.unpair();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
