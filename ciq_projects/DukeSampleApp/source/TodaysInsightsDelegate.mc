import Toybox.Lang;
import Toybox.WatchUi;

class TodaysInsightsDelegate extends WatchUi.BehaviorDelegate {
    // Will need viewController for further analysis pages
    private var _viewController as ViewController;
    private var _scanDataModel as ScanDataModel;

    // public function initialize(viewController as ViewController) {
    public function initialize(viewController as ViewController, scanDataModel as ScanDataModel) {
        BehaviorDelegate.initialize();
        _viewController = viewController;
        _scanDataModel = scanDataModel;
    }

    // If the user swipes up, go to the Graph screen
    // If the user swipes down, go to the Main screen
    public function onSwipe(swipeEvent as SwipeEvent) as Boolean {
        System.println("Swipe direction: " + swipeEvent.getDirection());
        if (swipeEvent.getDirection() == 0){
            _viewController.pushGraphView();
            return true;
        }
        if (swipeEvent.getDirection() == 2){
            var displayResult = _scanDataModel.getDisplayResult();
            if (null != displayResult) {
                _viewController.pushMainView(displayResult);
            }
            return true;
        }
        return false;
    }
    
    // If the user taps on total exposure, go to the graph screen
    // public function onMenuItem(item as Symbol) as Boolean {
    //     if (item == :total_exposure) {
    //         _viewController.pushGraphView();
    //         return true;
    //     }
    //     return false;
    // }

    public function onBack() as Boolean {
        // Return to main screen
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
