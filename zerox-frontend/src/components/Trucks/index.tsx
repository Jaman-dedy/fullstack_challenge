import { TruckIcon, Battery100Icon, Battery50Icon, Battery0Icon } from '@heroicons/react/24/outline'
import React from 'react'
import Layout from '@/components/Layout'
import Table from '@/components/common/Table'


const headers = [
  { key: 'title', label: 'Title' },
  { key: 'description', label: 'Description' },
  { key: 'icon', label: 'Icon' },
  { key: 'batStatus', label: 'Battery Status' },
  { key: 'batteryPercentage', label: 'Battery Percentage' },
  { key: 'chargingStation', label: 'Charging Station' },
  { key: 'location', label: 'Location' },
  { key: 'status', label: 'Status' },
];

const items = [
  { title: 'ZEROX001-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 1', batteryPercentage: 100, location: 'Warehouse A', status: 'Available' },
  { title: 'ZEROX002-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 2', batteryPercentage: 50, location: 'Warehouse B', status: 'Charging' },
  { title: 'ZEROX003-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 3', batteryPercentage: 20, location: 'Warehouse C', status: 'In Transit' },
  { title: 'ZEROX004-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 4', batteryPercentage: 100, location: 'Warehouse A', status: 'Available' },
  { title: 'ZEROX005-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 5', batteryPercentage: 50, location: 'Warehouse B', status: 'Charging' },
  { title: 'ZEROX006-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 6', batteryPercentage: 20, location: 'Warehouse C', status: 'In Transit' },
  { title: 'ZEROX007-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 7', batteryPercentage: 100, location: 'Warehouse D', status: 'Available' },
  { title: 'ZEROX008-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 8', batteryPercentage: 50, location: 'Warehouse A', status: 'Charging' },
  { title: 'ZEROX009-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 9', batteryPercentage: 20, location: 'Warehouse B', status: 'In Transit' },
  { title: 'ZEROX010-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 10', batteryPercentage: 100, location: 'Warehouse C', status: 'Available' },
  { title: 'ZEROX011-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 1', batteryPercentage: 50, location: 'Warehouse D', status: 'Charging' },
  { title: 'ZEROX012-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 2', batteryPercentage: 20, location: 'Warehouse A', status: 'In Transit' },
  { title: 'ZEROX013-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 3', batteryPercentage: 100, location: 'Warehouse B', status: 'Available' },
  { title: 'ZEROX014-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 4', batteryPercentage: 50, location: 'Warehouse C', status: 'Charging' },
  { title: 'ZEROX015-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 5', batteryPercentage: 20, location: 'Warehouse D', status: 'In Transit' },
  { title: 'ZEROX016-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 6', batteryPercentage: 100, location: 'Warehouse A', status: 'Available' },
  { title: 'ZEROX017-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 7', batteryPercentage: 50, location: 'Warehouse B', status: 'Charging' },
  { title: 'ZEROX018-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 8', batteryPercentage: 20, location: 'Warehouse C', status: 'In Transit' },
  { title: 'ZEROX019-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 9', batteryPercentage: 100, location: 'Warehouse D', status: 'Available' },
  { title: 'ZEROX020-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 10', batteryPercentage: 50, location: 'Warehouse A', status: 'Charging' },
  { title: 'ZEROX021-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 1', batteryPercentage: 20, location: 'Warehouse B', status: 'In Transit' },
  { title: 'ZEROX022-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 2', batteryPercentage: 100, location: 'Warehouse C', status: 'Available' },
  { title: 'ZEROX023-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 3', batteryPercentage: 50, location: 'Warehouse D', status: 'Charging' },
  { title: 'ZEROX024-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 4', batteryPercentage: 20, location: 'Warehouse A', status: 'In Transit' },
  { title: 'ZEROX025-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 5', batteryPercentage: 100, location: 'Warehouse B', status: 'Available' },
  { title: 'ZEROX026-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 6', batteryPercentage: 50, location: 'Warehouse C', status: 'Charging' },
  { title: 'ZEROX027-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 7', batteryPercentage: 20, location: 'Warehouse D', status: 'In Transit' },
  { title: 'ZEROX028-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 8', batteryPercentage: 100, location: 'Warehouse A', status: 'Available' },
  { title: 'ZEROX029-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 9', batteryPercentage: 50, location: 'Warehouse B', status: 'Charging' },
  { title: 'ZEROX030-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 10', batteryPercentage: 20, location: 'Warehouse C', status: 'In Transit' },
  { title: 'ZEROX031-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 1', batteryPercentage: 100, location: 'Warehouse D', status: 'Available' },
  { title: 'ZEROX032-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 2', batteryPercentage: 50, location: 'Warehouse A', status: 'Charging' },
  { title: 'ZEROX033-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 3', batteryPercentage: 20, location: 'Warehouse B', status: 'In Transit' },
  { title: 'ZEROX034-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 4', batteryPercentage: 100, location: 'Warehouse C', status: 'Available' },
  { title: 'ZEROX035-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 5', batteryPercentage: 50, location: 'Warehouse D', status: 'Charging' },
  { title: 'ZEROX036-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 6', batteryPercentage: 20, location: 'Warehouse A', status: 'In Transit' },
  { title: 'ZEROX037-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 7', batteryPercentage: 100, location: 'Warehouse B', status: 'Available' },
  { title: 'ZEROX038-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 8', batteryPercentage: 50, location: 'Warehouse C', status: 'Charging' },
  { title: 'ZEROX039-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 9', batteryPercentage: 20, location: 'Warehouse D', status: 'In Transit' },
  { title: 'ZEROX040-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 10', batteryPercentage: 100, location: 'Warehouse A', status: 'Available' },
  { title: 'ZEROX041-TN', description: 'Iveco Stralis', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 1', batteryPercentage: 50, location: 'Warehouse B', status: 'Charging' },
  { title: 'ZEROX042-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 2', batteryPercentage: 20, location: 'Warehouse C', status: 'In Transit' },
  { title: 'ZEROX043-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 3', batteryPercentage: 100, location: 'Warehouse D', status: 'Available' },
  { title: 'ZEROX044-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 4', batteryPercentage: 50, location: 'Warehouse A', status: 'Charging' },
  { title: 'ZEROX045-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-red-500', batStatus: Battery0Icon, chargingStation: 'Dock 5', batteryPercentage: 20, location: 'Warehouse B', status: 'In Transit' },
  { title: 'ZEROX046-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, chargingStation: 'Dock 6', batteryPercentage: 100, location: 'Warehouse C', status: 'Available' },
  { title: 'ZEROX047-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 7', batteryPercentage: 50, location: 'Warehouse D', status: 'Charging' },
  { title: 'ZEROX048-TN', description: 'Iveco Stralis', icon: TruckIcon, background:'bg-yellow-500', batStatus: Battery50Icon, chargingStation: 'Dock 7', batteryPercentage: 50, location: 'Warehouse D', status: 'Charging'}]
  
  export default function Trucks() {
    return (
      <Layout>
        <div className="sm:flex sm:items-center mb-5">
        <div className="sm:flex-auto">
          <h1 className="text-base font-semibold leading-6 text-gray-900">Trucks</h1>
          <p className="mt-2 text-sm text-gray-700">
            A list of all the trucks with their details.
          </p>
        </div>
        <div className="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
          <button
            type="button"
            className="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            Print
          </button>
        </div>
      </div>
        <Table headers={headers} items={items} />
      </Layout>
    )
  }
  