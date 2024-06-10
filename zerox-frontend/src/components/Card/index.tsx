// Not using this

import React from 'react';
import { motion } from 'framer-motion';
import { TruckIcon } from '@heroicons/react/24/outline';

import DropIndicator from '@/components/DropIndicator';
import { CardType } from '@/types';
import { ChargingStatusIcon } from '../common/Icon';

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

type CardProps = CardType & {
  handleDragStart: Function;
  background?: string;
};

const Card = ({
  plateNumber,
  description,
  id,
  column,
  handleDragStart,
  background,
  chargingStatus,
}: CardProps) => {
  const isDraggable = column === 'need_to_be_charged';

  return (
    <>
      <DropIndicator beforeId={id} column={column} />
      {isDraggable ? (
        <motion.div
          layout
          layoutId={id}
          draggable='true'
          onDragStart={(e) => handleDragStart(e, { plateNumber, id, column })}
          className='relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-grab active:cursor-grabbing text-gray-900 shadow-md'
        >
          <div
            className={classNames(
              background,
              'flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {/* {icon &&
              React.createElement(icon, {
                className: 'h-6 w-6 text-white',
                'aria-hidden': 'true',
              })} */}
            <TruckIcon className='h-6 w-6 text-white' />
          </div>
          <div>
            <p className='text-sm text-gray-900'>{plateNumber}</p>
            <p className='text-sm text-gray-400'>{description}</p>
            <div className='flex items-center'>
              <ChargingStatusIcon chargingStatus={chargingStatus} />
            </div>
          </div>
        </motion.div>
      ) : (
        <div
          className={`relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-not-allowed shadow-md ${
            column === 'fully_charged' ? 'mb-2' : ''
          }`}
        >
          <div
            className={classNames(
              background,
              'flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {React.createElement(TruckIcon, {
              className: 'h-6 w-6 text-white',
              'aria-hidden': 'true',
            })}
          </div>
          <div>
            <p className='text-sm text-gray-900'>{plateNumber}</p>
            <p className='text-sm text-gray-400'>{description}</p>
            <div className='flex items-center'>
              <ChargingStatusIcon chargingStatus={chargingStatus} />
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Card;
