import React, { useMemo, useState } from 'react';
import { trucksData } from '@/data/trucks.ts';
import { useGetTrucks } from '@/hooks/useTrucks';
import { categorizeTrucks } from '@/helpers/trucks';
import TruckManagement from '@/components/TruckManagement';

const Board = () => {
  const [cards, setCards] = useState(trucksData);
  const { trucks, isLoading, error } = useGetTrucks();

  const { trucksFullyCharged, trucksOnCharge, trucksWaiting } = useMemo(() => {
    if (!trucks)
      return { trucksFullyCharged: [], trucksOnCharge: [], trucksWaiting: [] };
    return categorizeTrucks(trucks);
  }, [trucks]);

  return (
    <div>
      <h2 className='text-base font-semibold leading-6 text-gray-900'>
        Autonomous Trucks
      </h2>
      <p className='mt-1 text-sm text-gray-500'>
        Please check the battery status of the trucks here
      </p>
      <div className='relative mt-4'>
        <div className='absolute inset-0 flex items-center' aria-hidden='true'>
          <div className='w-full border-t border-gray-300' />
        </div>
        <div className='relative flex justify-center'>
          <span className='bg-white px-2 text-sm text-gray-500'></span>
        </div>
      </div>
      <TruckManagement
        title={''}
        headingColor={''}
        cards={[]}
        column={'fully_charged'}
        setCards={undefined}
      />
    </div>
  );
};

export default Board;
