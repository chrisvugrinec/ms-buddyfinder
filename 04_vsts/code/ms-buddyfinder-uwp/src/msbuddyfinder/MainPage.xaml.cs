using System.Collections.Generic;
using System;
using System.Linq;
using System.Threading;
using Windows.Devices.Bluetooth.Advertisement;
using Windows.UI.Core;
using Windows.UI.Xaml.Controls;
using msbuddyfinder.Model;

namespace msbuddyfinder
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    sealed partial class MainPage : Page
    {
        private readonly BluetoothLEAdvertisementWatcher watcher;
        private IList<BeaconInfo> beaconsInRange = new List<BeaconInfo>();

        public MainPage()
        {
            this.InitializeComponent();

            watcher = new BluetoothLEAdvertisementWatcher { ScanningMode = BluetoothLEScanningMode.Active };
            watcher.Received += WatcherOnReceived;
            watcher.Start();

            var timer = new Timer(callback, null, 0, 5000);
        }

        private async void UpdateTextBox(BeaconInfo beacon)
        {
            await Windows.ApplicationModel.Core.CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                {
                    if (beacon == null)
                    {
                        this.txtBeaconName.Text = string.Empty;
                        this.txtBeaconRange.Text = string.Empty;

                    }
                    else
                    {
                        this.txtBeaconName.Text = beacon.LocalName;
                        this.txtBeaconRange.Text = $"{beacon.Proximity} ( {beacon.RawSignalStrengthInDBm} DBm )";
                    }
                });
        }

        private void callback(object state)
        {
            if (this.beaconsInRange.Any())
            {
                var nearestBeacon = this.beaconsInRange.OrderByDescending(beacon => beacon.RawSignalStrengthInDBm).First();
                this.UpdateTextBox(nearestBeacon);
            }
            else
            {
                this.UpdateTextBox(null);
            }
        }

        private void WatcherOnReceived(BluetoothLEAdvertisementWatcher sender, BluetoothLEAdvertisementReceivedEventArgs args)
        {
            var beaconExposesProperName = args?.Advertisement?.LocalName.Length > 0;

            // Ignore 'beacons' that do not expose proper name - e.g. other bluetooth devices
            if (!beaconExposesProperName)
            {
                return;
            }

            var key = args.Advertisement.LocalName;
            var beaconInfo = new BeaconInfo(key, args.BluetoothAddress, args.RawSignalStrengthInDBm, args.Timestamp, args.AdvertisementType, args.Advertisement.ServiceUuids);

            var beaconIsAlreadyInScope = this.beaconsInRange.Any(b => b.LocalName == key);

            if (beaconIsAlreadyInScope)
            {
                var beacon = this.beaconsInRange.Single(b => b.LocalName == key);
                beacon.RawSignalStrengthInDBm = beaconInfo.RawSignalStrengthInDBm;
            }
            else
            {
                this.beaconsInRange.Add(beaconInfo);
            }
        }
    }
}