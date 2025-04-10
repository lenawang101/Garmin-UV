import Toybox.Lang;
import Toybox.WatchUi;

class TodaysInsightsDelegate extends WatchUi.BehaviorDelegate {
    // Will need viewController for further analysis pages
    private var _viewController as ViewController;

    public function initialize(viewController as ViewController) {
        BehaviorDelegate.initialize();
        _viewController = viewController;
    }

    // If the user taps anywhere, go to the Graph screen
    public function onTap(clickEvent as ClickEvent) as Boolean {
        _viewController.pushGraphView();
        return true;
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
