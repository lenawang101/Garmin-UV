import Toybox.Lang;
import Toybox.WatchUi;

class SunscreenReminderDelegate extends WatchUi.BehaviorDelegate {
    // Will need viewController for further analysis pages
    // private var _viewController as ViewController;

    public function initialize(viewController as ViewController) {
        BehaviorDelegate.initialize();
        // _viewController = viewController;
    }

    public function onTap(clickEvent as ClickEvent) as Boolean {
        WatchUi.popView(WatchUi.SLIDE_UP);
        return true;
    }
    

    public function onBack() as Boolean {
        // Return to main screen
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
