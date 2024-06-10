import React, { FunctionComponent } from 'react';
import {
  Battery0Icon,
  Battery100Icon,
  Battery50Icon,
} from '@heroicons/react/24/outline';
import { TruckChargingStatus } from '@/types';

export interface StatusConfig {
  icon: FunctionComponent<any>;
  className: string;
  spinner?: boolean;
}

export type ChargingStatusMap = {
  [key in TruckChargingStatus]: StatusConfig;
};

const statusConfig: ChargingStatusMap = {
  [TruckChargingStatus.Charged]: {
    icon: Battery100Icon,
    className: 'h-5 w-5 flex-shrink-0 text-green-500',
  },
  [TruckChargingStatus.NotCharged]: {
    icon: Battery0Icon,
    className: 'h-5 w-5 flex-shrink-0 text-red-500 animate-pulse',
  },
  [TruckChargingStatus.OnCharge]: {
    icon: Battery50Icon,
    className: 'h-5 w-5 flex-shrink-0 text-yellow-500',
    spinner: true,
  },
};

interface ChargingStatusIconProps {
  chargingStatus: TruckChargingStatus;
}

const ChargingStatusIcon: React.FC<ChargingStatusIconProps> = ({
  chargingStatus,
}) => {
  const {
    icon: IconComponent,
    className,
    spinner,
  } = statusConfig[chargingStatus];

  return (
    <>
      {IconComponent && (
        <IconComponent className={className} aria-hidden={true} />
      )}
      {spinner && (
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
      )}
    </>
  );
};

export default ChargingStatusIcon;
