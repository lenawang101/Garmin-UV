import Toybox.Lang;
import Toybox.WatchUi;

class GraphInsightsDelegate extends WatchUi.BehaviorDelegate {
    // Will need viewController for further analysis pages
    private var _viewController as ViewController;

    public function initialize(viewController as ViewController) {
        BehaviorDelegate.initialize();
        _viewController = viewController;
    }

    public function onTap(clickEvent as ClickEvent) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    // If the user swipes down, go to the Insights screen
    public function onSwipe(swipeEvent as SwipeEvent) as Boolean {
        if (swipeEvent.getDirection() == 2){
            _viewController.pushInsightsView();
            return true;
        }
        else if (swipeEvent.getDirection() == 0){
            _viewController.pushRawDataView();
            return true;
        }
        return false;
    }
    

    public function onBack() as Boolean {
        // Return to main screen
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
