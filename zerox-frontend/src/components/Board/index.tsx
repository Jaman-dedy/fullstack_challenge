import React, {useState} from 'react';

import Column from '@/components/Column';
import {trucksData} from '@/data/trucks.ts'


const Board = ({updateTruckCount, updateChargedTruckCount, updateChargingStationCount}) => {
    const [cards, setCards] = useState(trucksData);

    const handleTruckCountChange = (count) => {
      updateTruckCount(count);
    };
  
    const handleChargedTruckCountChange = (count) => {
      updateChargedTruckCount(count);
    };
  
    const handleChargingStationCountChange = (count) => {
      updateChargingStationCount(count);
    };
  
    return (
      <div className="px-4 mt-6">
        <h2 className="text-base font-semibold leading-6 text-gray-900">Autonomous Trucks</h2>
            <p className="mt-1 text-sm text-gray-500">
                Please check the battery status of the trucks here
            </p>
            <div className="relative mt-4">
                <div className="absolute inset-0 flex items-center" aria-hidden="true">
                    <div className="w-full border-t border-gray-300" />
                </div>
                <div className="relative flex justify-center">
                    <span className="bg-white px-2 text-sm text-gray-500"></span>
                </div>
            </div>
      <div className="mt-4 grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
    
        <Column
          title="Truck charged"
          column="fully_charged"
          headingColor="text-neutral-500"
          cards={cards}
          setCards={setCards}
          onTruckCountChange={handleChargedTruckCountChange}
        />
        <Column
          title="Need to be charged"
          column="need_to_be_charged"
          headingColor="text-blue-200"
          cards={cards}
          setCards={setCards}
          onTruckCountChange={handleTruckCountChange}
        />
        <Column
          title="Charging stations"
          column="docks"
          headingColor="text-emerald-200"
          cards={cards}
          setCards={setCards}
          dockCounts={10}
          onChargingStationCountChange={handleChargingStationCountChange}
        />
      </div>
      </div>
    );
  };

  export default Board