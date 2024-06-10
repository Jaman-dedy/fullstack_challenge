import React from 'react';
import { Droppable } from 'react-beautiful-dnd';

import { TruckIcon } from '@heroicons/react/24/outline';
import ChargingStatusIcon from '../common/Icon/ChargingStatusIcon';
import { Truck } from '@/types';

const FullyChargedTrucks = ({
  trucksFullyCharged,
}: {
  trucksFullyCharged: Truck[];
}) => (
  <Droppable droppableId='fullyCharged'>
    {(provided: any) => (
      <div className='w-56 shrink-0'>
        <div className='mb-3 flex items-center justify-between'>
          <h3 className={`font-medium text-neutral-500`}>
            Fully Charged Trucks
          </h3>
          <span className='rounded text-sm text-neutral-400'>
            {trucksFullyCharged && trucksFullyCharged.length}
          </span>
        </div>
        <div
          ref={provided.innerRef}
          {...provided.droppableProps}
          className={`h-full w-full transition-colors ${
            false ? 'bg-neutral-800/50' : 'bg-neutral-800/0'
          }`}
        >
          {trucksFullyCharged &&
            trucksFullyCharged.map((truck, index) => (
              <div
                key={truck.id}
                className='relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-grab active:cursor-grabbing text-gray-900 shadow-md'
              >
                <div className='flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg bg-green-500'>
                  <TruckIcon className='h-6 w-6 text-white' />
                </div>
                <div>
                  <p className='text-sm text-gray-900'>{truck.plateNumber}</p>
                  <p className='text-sm text-gray-400'>{truck.description}</p>
                  <div className='flex items-center'>
                    <ChargingStatusIcon chargingStatus={truck.chargingStatus} />
                  </div>
                </div>
              </div>
            ))}
          {provided.placeholder}
        </div>
      </div>
    )}
  </Droppable>
);

export default FullyChargedTrucks;
