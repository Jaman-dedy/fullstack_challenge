import { Truck, TruckChargingStatus } from '@/types';
import { trucksData } from '@/data/trucks';

let trucks: Truck[] = trucksData;

export const retrieveTrucks = (): Truck[] => {
  return trucks;
};

export const updateTruck = (updatedTruck: Truck): Truck[] => {
  trucks = trucks.map((truck: Truck) => {
    if (truck.id === updatedTruck.id) {
      return updatedTruck; // Correctly return the updated truck
    }
    return truck;
  });
  return trucks;
};

export const categorizeTrucks = (trucks: Truck[]) => {
  const trucksFullyCharged = trucks.filter(
    (truck) => TruckChargingStatus.Charged === truck.chargingStatus
  );
  const trucksOnCharge = trucks.filter(
    (truck) => TruckChargingStatus.OnCharge == truck.chargingStatus
  );
  const trucksWaiting = trucks.filter(
    (truck) => TruckChargingStatus.NotCharged === truck.chargingStatus
  );

  return {
    trucksFullyCharged,
    trucksOnCharge,
    trucksWaiting,
  };
};
