using System;
using System.Collections.Generic;
using Windows.Devices.Bluetooth.Advertisement;

namespace msbuddyfinder.Model
{
    public class BeaconInfo
    {
        private DateTimeOffset timestamp;

        public BeaconInfo(string localName, ulong bluetoothAddress, short rawSignalStrengthInDBm, DateTimeOffset timestamp, BluetoothLEAdvertisementType advertisementType, IList<Guid> serviceUuids)
        {
            this.LocalName = localName;
            this.BluetoothAddress = bluetoothAddress;
            this.RawSignalStrengthInDBm = rawSignalStrengthInDBm;
            this.timestamp = timestamp;
            this.AdvertisementType = advertisementType;
            this.ServiceUuids = serviceUuids;
        }

        public string LocalName { get; set; }
        public ulong BluetoothAddress { get; set; }
        public short RawSignalStrengthInDBm { get; set; }
        public TimeSpan TimeStamp { get; set; }
        public BluetoothLEAdvertisementType AdvertisementType { get; set; }
        public IList<Guid> ServiceUuids { get; set; }

        public ProximityEnum Proximity
        {
            get
            {
                return this.RawSignalStrengthInDBm > -50 ? ProximityEnum.Near : ProximityEnum.Far;
            }
        }

        public enum ProximityEnum
        {
            Near,
            Far
        }

        public override string ToString()
        {
            return $"Beacon => name : {this.LocalName}, signalStrength: {this.RawSignalStrengthInDBm}";
        }
    }
}