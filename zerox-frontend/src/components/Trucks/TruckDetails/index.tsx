'use client'

import { BoltIcon, InformationCircleIcon } from '@heroicons/react/24/outline';
import Layout from '@/components/Layout'
import truckImg from '@/assets/truck.jpg'
import Image from 'next/image'

const truck = {
  id: 'ZEROX001-TN',
  status: 'Available',
  lastTrip: {
    origin: 'Warehouse A',
    destination: 'Mine Site X',
    distance: '120 km',
    duration: '2 hours',
    route: truckImg,
  },
  batteryLevel: 100,
  maintenanceStatus: 'Up to date',
  lastMaintenance: '2023-05-15',
  nextMaintenance: '2023-08-15',
};

export default function TruckDetails() {
  return (
    <Layout>
      <div className="mx-auto max-w-7xl px-4 py-3 sm:px-6 lg:px-8">
      <div className="sm:flex-auto mb-5">
          <h1 className="text-base font-semibold leading-6 text-gray-900">Trucks</h1>
          <p className="mt-2 text-sm text-gray-700">
            A list of all the trucks with their details.
          </p>
        </div>
        <div className="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-3">
          <div className="lg:col-start-3 lg:row-end-1">
            <h2 className="sr-only">Summary</h2>
            <div className="rounded-lg bg-gray-50 shadow-sm ring-1 ring-gray-900/5">
              <dl className="flex flex-wrap">
                <div className="flex-auto pl-6 pt-6">
                  <dt className="text-sm font-semibold leading-6 text-gray-900">Status {truck.status}</dt>
                </div>
                <div className="mt-6 flex w-full flex-none gap-x-4 border-t border-gray-900/5 px-6 pt-6">
                  <dt className="flex-none">
                    <span className="sr-only">Battery</span>
                    <BoltIcon className="h-6 w-5 text-gray-400" aria-hidden="true" />
                  </dt>
                  <dd className="text-sm font-medium leading-6 text-gray-900">{truck.batteryLevel}%</dd>
                </div>
                <div className="mt-4 flex w-full flex-none gap-x-4 px-6">
                  <dt className="flex-none">
                    <span className="sr-only">Last Maintenance</span>
                    <InformationCircleIcon className="h-6 w-5 text-gray-400" aria-hidden="true" />
                  </dt>
                  <dd className="text-sm leading-6 text-gray-500">
                    <time dateTime={truck.lastMaintenance}>{truck.lastMaintenance}</time>
                  </dd>
                </div>
                <div className="mt-4 mb-4 flex w-full flex-none gap-x-4 px-6">
                  <dt className="flex-none">
                    <span className="sr-only">Next Maintenance</span>
                    <InformationCircleIcon className="h-6 w-5 text-gray-400" aria-hidden="true" />
                  </dt>
                  <dd className="text-sm leading-6 text-gray-500">
                    <time dateTime={truck.nextMaintenance}>{truck.nextMaintenance}</time>
                  </dd>
                </div>
              </dl>
            </div>
          </div>

          <div className="-mx-4 px-4 py-4 shadow-sm ring-1 ring-gray-900/5 sm:mx-0 sm:rounded-lg sm:px-8 sm:pb-14 lg:col-span-2 lg:row-span-2 lg:row-end-2 xl:px-8 xl:pb-20 xl:pt-8">
            <h2 className="text-base font-semibold leading-6 text-gray-900">Truck Details</h2>
            <dl className="mt-6 grid grid-cols-1 text-sm leading-6 sm:grid-cols-2">
              <div className="sm:pr-4">
                <dt className="inline text-gray-500">Truck ID</dt>{' '}
                <dd className="inline text-gray-700">{truck.id}</dd>
              </div>
              <div className="mt-2 sm:mt-0 sm:pl-4">
                <dt className="inline text-gray-500">Status</dt>{' '}
                <dd className="inline text-gray-700">{truck.status}</dd>
              </div>
              <div className="mt-6 border-t border-gray-900/5 pt-6 sm:pr-4">
                <dt className="font-semibold text-gray-900">Last Trip</dt>
                <dd className="mt-2 text-gray-500">
                  <p>Origin: {truck.lastTrip.origin}</p>
                  <p>Destination: {truck.lastTrip.destination}</p>
                  <p>Distance: {truck.lastTrip.distance}</p>
                  <p>Duration: {truck.lastTrip.duration}</p>
                </dd>
              </div>
              <div className="mt-6 border-t border-gray-900/5 pt-6 sm:pl-4">
                <dt className="font-semibold text-gray-900">Maintenance</dt>
                <dd className="mt-2 text-gray-500">
                  <p>Status: {truck.maintenanceStatus}</p>
                  <p>Last Maintenance: {truck.lastMaintenance}</p>
                  <p>Next Maintenance: {truck.nextMaintenance}</p>
                </dd>
              </div>
            </dl>

            {/* Trip Map */}
            <div className="mt-8">
              <h3 className="text-base font-semibold leading-6 text-gray-900">Last Trip Route</h3>
              <div className="mt-4 aspect-w-4 aspect-h-2 rounded-lg bg-gray-100">
                {/* Replace this with the actual map component */}
                <Image
                src={truck.lastTrip.route}
                width ={1000}
                height ={1000}
                alt="map"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}