import Trucks from '@/components/Truck'
import Docks from '@/components/Dock'
import Layout from '@/components/Layout'
import Stats from '@/components/Stats'
import './style.css'

export default function Home() {
  

  return (
      <Layout>
          <div className="lg:mx-4 mx-2">
            <Stats />
          </div>
          <div className="mx-auto w-full gap-4 max-w-7xl grow lg:flex xl:px-4 h-full">
            <div className="flex-1 xl:flex">
              <div className="hide-scrollbar overflow-y-auto my-5 mx-2 lg:mx-0 lg:my-6 rounded-xl text-black border-dashed border-2 border-gray-200 px-4 lg:pl-6 py-6 lg:pl-8 xl:flex-1 xl:pl-6  sm:px-6">
                <Trucks />
              </div>
            </div>
            <div className="lg:my-6 mx-2 lg:mx-0 rounded-xl text-black shrink-0 border-dashed border-2 border-gray-200 px-4 py-6 sm:px-6 lg:w-[32.2%] lg:border-dashed lg:border-dashed lg:pr-8 xl:pr-6">
              <Docks />
            </div>
          </div>
      </Layout>
  );
}