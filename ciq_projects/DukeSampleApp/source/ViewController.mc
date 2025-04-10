//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;

class ViewController {
    private var _modelFactory as DataModelFactory;

    //! Constructor
    //! @param modelFactory Factory to create models
    public function initialize(modelFactory as DataModelFactory) {
        _modelFactory = modelFactory;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [ScanView] or [ScanView, ScanDelegate] {
        var scanDataModel = _modelFactory.getScanDataModel();

        return [new $.ScanView(scanDataModel), new $.ScanDelegate(scanDataModel, self)];
    }

    //! Push the scan menu view (hold menu button to push this view)
    public function pushScanMenu() as Void {
        WatchUi.pushView(new $.Rez.Menus.MainMenu(), new $.ScanMenuDelegate(), WatchUi.SLIDE_UP);
    }

    //! Push the device view
    //! @param scanResult The scan result for the device view to push
    public function pushDeviceView(scanResult as ScanResult) as Void {
        var deviceDataModel = _modelFactory.getDeviceDataModel(scanResult);
        var deviceView = new $.DeviceView(deviceDataModel);
        _modelFactory.GetPhoneCommunication().setDeviceView(deviceView);

        WatchUi.pushView(deviceView, new $.DeviceDelegate(deviceDataModel, deviceView), WatchUi.SLIDE_UP);
    }

    // Return the “Main” screen as the initial view for the app
    // public function getMainView() as [MainView] or [MainView, MainDelegate] {
    //     var mainView = new MainView();
    //     var mainDelegate = new MainDelegate(self);
    //     return [mainView, mainDelegate];
    // }

    // Push the “Today’s Insights” screen
    public function pushInsightsView() as Void {
        var scanDataModel = _modelFactory.getScanDataModel();
        var insightsView = new TodaysInsightsView();
        // var insightsDelegate = new TodaysInsightsDelegate(self);
        var insightsDelegate = new TodaysInsightsDelegate(self, scanDataModel);
        WatchUi.pushView(insightsView, insightsDelegate, WatchUi.SLIDE_LEFT);
    }

    public function pushGraphView() as Void {
        var insightsView = new GraphInsightsView();
        var insightsDelegate = new GraphInsightsDelegate(self);
        WatchUi.pushView(insightsView, insightsDelegate, WatchUi.SLIDE_LEFT);
    }

    public function pushMainView(scanResult as ScanResult) as Void {
        var deviceDataModel = _modelFactory.getDeviceDataModel(scanResult);

        // Pair now, so the watch actually connects in the background
        deviceDataModel.pair();

        var mainView = new MainView(deviceDataModel);
        var mainDelegate = new MainDelegate(self, deviceDataModel, mainView);

        // If you want phone comm for other reasons, you can set it here
        // _modelFactory.GetPhoneCommunication().setDeviceView(deviceViewOrSomething);

        WatchUi.pushView(mainView, mainDelegate, WatchUi.SLIDE_UP);
    }
}