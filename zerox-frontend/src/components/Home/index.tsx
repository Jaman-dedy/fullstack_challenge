'use client'
import React, { useState } from 'react';
import Layout from '@/components/Layout'
import Stats from '@/components/Stats'


import Board from '@/components/Board'

export default function CustomKanban () {

  const [truckCount, setTruckCount] = useState(48);
  const [chargedTruckCount, setChargedTruckCount] = useState(0);
  const [chargingStationCount, setChargingStationCount] = useState(10);

  const handleTruckCountChange = (count) => {
    setTruckCount(count);
  };

  const handleChargedTruckCountChange = (count) => {
    setChargedTruckCount(count);
  };

  const handleChargingStationCountChange = (count) => {
    setChargingStationCount(count);
  };
  
  return (
    <Layout>
       <div className="lg:mx-4 mx-2">
          <Stats 
          truckCount={truckCount} 
          chargedTruckCount={chargedTruckCount}
          chargingStationCount={chargingStationCount}
          />
        </div>
      <Board
      updateTruckCount={handleTruckCountChange}
      updateChargedTruckCount={handleChargedTruckCountChange}
      updateChargingStationCount={handleChargingStationCountChange}
      />
    </Layout>
  );
};