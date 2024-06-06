import { TruckIcon, Battery100Icon, Battery50Icon, Battery0Icon, BoltIcon } from '@heroicons/react/24/outline'
import React from 'react'
import Layout from '@/components/Layout'
import Table from '@/components/common/Table'


const headers = [
  { key: 'title', label: 'Title' },
  { key: 'description', label: 'Description' },
  { key: 'icon', label: 'Icon' },
  { key: 'status', label: 'Status' },
  { key: 'truckNumber', label: 'Truck Number' },
  { key: 'chargingPower', label: 'Charging Power (kW)' },
  { key: 'chargingEfficiency', label: 'Charging Efficiency (%)' },
];

const items = [
  {
    title: 'Dock 1',
    description: 'Available',
    icon: BoltIcon,
    background: 'bg-gray-500',
    status: 'free',
    truckNumber: null,
    chargingPower: 50,
    chargingEfficiency: 95,
  },
  {
    title: 'Dock 2',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-gray-500',
    status: 'charging',
    speed: 4,
    truckNumber: 'ZEROX002-TN',
    chargingPower: 150,
    chargingEfficiency: 92,
  },
  {
    title: 'Dock 3',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-gray-500',
    status: 'charging',
    speed: 1,
    truckNumber: 'ZEROX005-TN',
    chargingPower: 100,
    chargingEfficiency: 90,
  },
  {
    title: 'Dock 4',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-gray-500',
    status: 'charging',
    speed: 5,
    truckNumber: 'ZEROX008-TN',
    chargingPower: 200,
    chargingEfficiency: 95,
  },
  {
    title: 'Dock 5',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-gray-500',
    status: 'charging',
    speed: 2,
    truckNumber: 'ZEROX011-TN',
    chargingPower: 120,
    chargingEfficiency: 93,
  },
  {
    title: 'Dock 6',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-yellow-500',
    status: 'charging',
    speed: 1,
    truckNumber: 'ZEROX014-TN',
    chargingPower: 80,
    chargingEfficiency: 91,
  },
  {
    title: 'Dock 7',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-yellow-500',
    status: 'charging',
    speed: 2,
    truckNumber: 'ZEROX017-TN',
    chargingPower: 110,
    chargingEfficiency: 94,
  },
  {
    title: 'Dock 8',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-yellow-500',
    status: 'charging',
    speed: 3,
    truckNumber: 'ZEROX020-TN',
    chargingPower: 130,
    chargingEfficiency: 92,
  },
  {
    title: 'Dock 9',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-yellow-500',
    status: 'charging',
    speed: 4,
    truckNumber: 'ZEROX023-TN',
    chargingPower: 180,
    chargingEfficiency: 96,
  },
  {
    title: 'Dock 10',
    description: 'Charging',
    icon: BoltIcon,
    background: 'bg-yellow-500',
    status: 'charging',
    speed: 5,
    truckNumber: 'ZEROX026-TN',
    chargingPower: 220,
    chargingEfficiency: 95,
  },
];
  
  export default function Trucks() {
    return (
      <Layout>
        <div className="sm:flex sm:items-center mb-5">
        <div className="sm:flex-auto">
          <h1 className="text-base font-semibold leading-6 text-gray-900">Charging stations</h1>
          <p className="mt-2 text-sm text-gray-700">
            A list of all the charging stations.
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
  