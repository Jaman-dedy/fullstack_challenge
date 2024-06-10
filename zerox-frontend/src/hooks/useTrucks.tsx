import { mutate } from 'swr';
import useFetch from './useFetch';
import { Truck, TruckChargingStatus } from '@/types';

type UseTrucksResponse = {
  trucks: Truck[];
  error: any;
  isLoading: boolean;
  mutate: any;
};

export function useGetTrucks(): UseTrucksResponse {
  // Fetch trucks from the server
  const URL = `api/trucks`;
  const { data, error, isLoading, mutate } = useFetch(URL);

  return {
    trucks: data?.trucks,
    error,
    isLoading,
    mutate, // for revalidating the cache with the new data
  };
}

// Hook to update a moved truck
export function useUpdateMovedTruck() {
  const URL = `/api/trucks`;

  const updateTruck = async (truck: Truck) => {
    const response = await fetch(URL, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(truck),
    });

    if (!response.ok) {
      const errorResponse = await response.json();
      throw new Error(errorResponse.error || 'Error updating truck');
    }

    const updatedTruck = await response.json();

    return updatedTruck;
  };

  return { updateTruck };
}
