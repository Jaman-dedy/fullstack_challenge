export type ColumnType = 'fully_charged' | 'need_to_be_charged' | 'docks';

// export type CardType = {
//   // title: string;
//   // id: string;
//   // column: ColumnType;
//   // description: string;
//   // icon: any;
//   // background: any;
//   // batStatus: any;
// };

export type Truck = {
  id: string;
  plateNumber: string;
  description: string;
  chargingStatus: TruckChargingStatus;
  batteryLevel: number;
  dockStation?: string;
  column: string;
  // [name: string]: string | number;
};

export type CardType = Truck;

export enum TruckChargingStatus {
  OnCharge = 'on',
  Charged = 'full',
  NotCharged = 'waiting',
}
