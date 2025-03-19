import Toybox.Lang;
import Toybox.WatchUi;

class MainDelegate extends WatchUi.BehaviorDelegate {
    private var _viewController as ViewController;

    public function initialize(viewController as ViewController) {
        BehaviorDelegate.initialize();
        _viewController = viewController;
    }

    //! If the user taps anywhere, go to the Insights screen
    public function onTap(clickEvent as ClickEvent) as Boolean {
        _viewController.pushInsightsView();
        return true;
    }

    //! (Optional) handle back button
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
