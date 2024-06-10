import useSWR, { SWRConfiguration } from 'swr';

const fetcher = async (url: string, config = {}) => {
  try {
    const response = await fetch(url, config);
    if (response.ok) return response.json();
    if (response.status === 404) return response.json();
    const errorResponse = await response.json();
    if (errorResponse && errorResponse.error) {
      throw new Error(errorResponse.error);
    }
  } catch (error) {
    console.error('Error fetching data:', error);
    throw error;
  }
};

export default function useFetch(
  url: string | undefined | null,
  config = {},
  options?: SWRConfiguration
) {
  return useSWR(url, (url: string) => fetcher(url, config), { ...options });
}
