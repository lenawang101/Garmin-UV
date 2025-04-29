//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application;
import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

//! This app uses the Bluetooth Low Energy API to pair with devices.
class DukeSampleApp extends Application.AppBase {
    private var _bleDelegate as BluetoothDelegate?;
    private var _profileManager as ProfileManager?;
    private var _modelFactory as DataModelFactory?;
    private var _viewController as ViewController?;
    var _phoneCommunication as PhoneCommunication;

    //! Constructor
    public function initialize() {
        AppBase.initialize();        
        _phoneCommunication = new PhoneCommunication();
    }

    private function uploadUVReadingToServer(uvVal as Number) as Void {

        var url = "https://hdpy7332gkmx.share.zrok.io/api/uv";   // matches Flask route

        var payload = {
            "uv"        => uvVal,                   // required field
            "user_id"   => "darren",                // or whatever ID you prefer
            "timestamp" => Time.now().value()       // epoch seconds
        };

        var opts = {
            :method       => Communications.HTTP_REQUEST_METHOD_POST,
            :headers      => { "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        /* fire‑and‑forget; we’ll still log the response in onUploadResponse() */
        Communications.makeWebRequest(url, payload, opts, self.method(:onUploadResponse));
        System.println("Upload succeeded");
    }

    // This is the callback that gets called once the server responds
    public function onUploadResponse(statusCode as Number, data as String) as Void {
        System.println("Upload response code: " + statusCode);
        System.println("Response body: " + data);

        // 2xx indicates success
        if (statusCode >= 200 && statusCode < 300) {
            System.println("Upload succeeded, clearing local uv data...");
            // Clears only the "uvReadings" array, leaving any other stored keys alone
            Storage.clearValues();
        } else {
            System.println("Upload failed, NOT clearing local data.");
        }
    }
    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {
        // Try uploaded stored data to local server, if succeeds, delete local data. 
        // uploadUVReadingToServer();
        Storage.clearValues();
        

        _profileManager = new $.ProfileManager();
        _bleDelegate = new $.BluetoothDelegate(_profileManager as ProfileManager);
        _modelFactory = new $.DataModelFactory(_bleDelegate as BluetoothDelegate, _profileManager as ProfileManager, _phoneCommunication as PhoneCommunication);
        _viewController = new $.ViewController(_modelFactory as DataModelFactory);

        BluetoothLowEnergy.setDelegate(_bleDelegate as BluetoothDelegate);
        if (_profileManager != null) {
            _profileManager.registerProfiles();
        }
    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
        _viewController = null;
        _modelFactory = null;
        _profileManager = null;
        _bleDelegate = null;
    }

    //! Return the initial views for the app
    //! @return Array Pair [View, InputDelegate]
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return _viewController.getInitialView();
    }

}