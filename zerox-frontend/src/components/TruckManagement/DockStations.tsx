import React from 'react';
import { Droppable } from 'react-beautiful-dnd';
import {
  BoltIcon,
  LockOpenIcon,
  LockClosedIcon,
} from '@heroicons/react/24/outline';

import { Truck } from '@/types';

export type DockStation = {
  id: string;
  name: string;
  occupied: boolean;
  truck: Truck | null;
};

const DockStations = ({
  sortedDockStations,
}: {
  sortedDockStations: DockStation[];
}) => (
  <div className='w-56 shrink-0'>
    <div className='mb-3 flex items-center justify-between'>
      <h3 className={`font-medium text-neutral-500`}>Dock Stations</h3>
      <span className='rounded text-sm text-neutral-400'>{3}</span>
    </div>
    <div
      className={`h-full w-full transition-colors ${
        false ? 'bg-neutral-800/50' : 'bg-neutral-800/0'
      }`}
    >
      {sortedDockStations.map((dock, index) => (
        <Droppable key={dock.id} droppableId={dock.id}>
          {(provided: any) => (
            <div
              ref={provided.innerRef}
              {...provided.droppableProps}
              className='min-h-12 relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-grab active:cursor-grabbing text-gray-900 shadow-md'
            >
              <div className='flex flex-col'>
                <h4 className='text-base font-normal text-gray-900'>
                  {dock.occupied && dock.truck
                    ? `${dock.name} -> ${dock.truck.plateNumber}`
                    : dock.name}
                </h4>
                <div className='mt-1 flex items-baseline justify-between md:block lg:flex relative z-10'>
                  <div className='flex items-baseline text-2xl font-semibold text-indigo-600'>
                    {dock.occupied && dock.truck
                      ? `${dock.truck.batteryLevel}%`
                      : 'Available'}
                    <span className='ml-2 text-sm font-medium text-gray-500'>
                      {dock.occupied && dock.truck ? (
                        <div className='flex items-center'>
                          <LockClosedIcon className='h-4 w-4 flex-shrink-0 text-yellow-500' />
                          <svg
                            className='h-4 w-4 ml-1 text-yellow-500 animate-spin'
                            fill='none'
                            viewBox='0 0 24 24'
                          >
                            <circle
                              className='opacity-25'
                              cx='12'
                              cy='12'
                              r='10'
                              stroke='currentColor'
                              strokeWidth='4'
                            />
                            <path
                              className='opacity-75'
                              fill='currentColor'
                              d='M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z'
                            />
                          </svg>
                        </div>
                      ) : (
                        <LockOpenIcon className='h-4 w-4 text-gray-500' />
                      )}
                    </span>
                  </div>
                  {dock.occupied && dock.truck && (
                    <div className='relative inline-flex items-center justify-center rounded-full p-2 text-yellow-500 md:mt-2 lg:mt-0'>
                      <BoltIcon
                        className='h-6 w-6 relative z-10 animate-breathe'
                        aria-hidden='true'
                      />
                    </div>
                  )}
                </div>
              </div>
              {provided.placeholder}
            </div>
          )}
        </Droppable>
      ))}
    </div>
  </div>
);

export default DockStations;
