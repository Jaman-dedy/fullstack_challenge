import React, { useState, useMemo, useEffect } from 'react';
import { DragDropContext } from 'react-beautiful-dnd';
import { useGetTrucks } from '@/hooks/useTrucks';
import { categorizeTrucks } from '@/helpers/trucks';
import { Truck, TruckChargingStatus } from '@/types';
import { useUpdateMovedTruck } from '@/hooks/useTrucks';
import DockStations, { DockStation } from './DockStations';
import FullyChargedTrucks from './FullyChargedTrucks';
import TrucksToCharge from './TrucksToCharge';

const generateInitialDockStations = (): DockStation[] =>
  Array.from({ length: 10 }, (_, index) => ({
    id: `dock-${index + 1}`,
    name: `Dock ${index + 1}`,
    occupied: false,
    truck: null,
  }));

const TruckManagement = () => {
  const { trucks, isLoading, error, mutate } = useGetTrucks();
  const { updateTruck } = useUpdateMovedTruck();

  const {
    trucksFullyCharged,
    trucksOnCharge,
    trucksWaiting: initialWaitingTrucks,
  } = useMemo(() => {
    if (!trucks)
      return { trucksFullyCharged: [], trucksOnCharge: [], trucksWaiting: [] };
    return categorizeTrucks(trucks);
  }, [trucks]);

  const [dockStations, setDockStations] = useState<DockStation[]>(
    generateInitialDockStations()
  );
  const [trucksWaiting, setTrucksWaiting] = useState<Truck[]>([]);

  useEffect(() => {
    setTrucksWaiting(initialWaitingTrucks);

    // Initialize dock stations with trucks on charge
    const updatedDockStations = generateInitialDockStations().map((dock) => {
      const truckOnCharge = trucksOnCharge.find(
        (truck) => truck.dockStation === dock.id
      );
      if (truckOnCharge) {
        return {
          ...dock,
          occupied: true,
          truck: truckOnCharge,
        };
      }
      return dock;
    });
    setDockStations(updatedDockStations);
  }, [initialWaitingTrucks, trucksOnCharge]);

  // Sort dockStations so that available docks are above occupied docks
  const sortedDockStations = useMemo(() => {
    return [...dockStations].sort(
      (a, b) => Number(a.occupied) - Number(b.occupied)
    );
  }, [dockStations]);

  const handleDrop = async (truck: Truck) => {
    const updatedTrucks = await updateTruck(truck);
    console.log(updatedTrucks);
    await mutate(); // Revalidate the cache with the new data
  };

  const onDragEnd = (result: any) => {
    const { source, destination } = result;

    if (!destination) return;

    // Moving within the same list
    if (source.droppableId === destination.droppableId) return;

    // Moving from waiting to dock station
    if (
      source.droppableId === 'waiting' &&
      destination.droppableId.startsWith('dock')
    ) {
      const waitingTrucks = Array.from(trucksWaiting);
      const dockIndex = dockStations.findIndex(
        (dock) => dock.id === destination.droppableId
      );

      if (dockStations[dockIndex].occupied) return; // Ignore if the dock is already occupied

      const [movedTruck] = waitingTrucks.splice(source.index, 1);
      const updatedDockStations = Array.from(dockStations);
      updatedDockStations[dockIndex].occupied = true;
      movedTruck.dockStation = updatedDockStations[dockIndex].id;
      movedTruck.chargingStatus = TruckChargingStatus.OnCharge;
      updatedDockStations[dockIndex].truck = movedTruck;

      setDockStations(updatedDockStations);
      setTrucksWaiting(waitingTrucks);
      handleDrop(movedTruck);
    }
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <DragDropContext onDragEnd={onDragEnd}>
      <div className='mt-4 grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3'>
        <FullyChargedTrucks trucksFullyCharged={trucksFullyCharged} />
        <TrucksToCharge trucksWaiting={trucksWaiting} />
        <DockStations sortedDockStations={sortedDockStations} />
      </div>
    </DragDropContext>
  );
};

export default TruckManagement;
