
// import React, {useState} from 'react';
// import Trucks from '@/components/Truck'
// import Docks from '@/components/Dock'
// import Layout from '@/components/Layout'
// import Stats from '@/components/Stats'

// import {trucksData} from '@/data/trucks'
// import {docksData} from '@/data/docks'
// import './style.css'

// export default function Home() {
//   const [trucks, setTrucks] = useState(trucksData);
//   const [docks, setDocks] = useState(docksData);

//   return (
//       <Layout>
//           <div className="lg:mx-4 mx-2">
//             <Stats/>
//           </div>
//           <div className="mx-auto w-full gap-4 max-w-7xl grow lg:flex xl:px-4 h-full">
//             <div className="flex-1 xl:flex">
//               <div className="hide-scrollbar overflow-y-auto my-5 mx-2 lg:mx-0 lg:my-6 rounded-xl text-black border-dashed border-2 border-gray-200 px-4 lg:pl-6 py-6 lg:pl-8 xl:flex-1 xl:pl-6  sm:px-6">
//                 <Trucks 
//                 item={trucks}
//                 />
//               </div>
//             </div>
//             <div className="lg:my-6 mx-2 lg:mx-0 rounded-xl text-black shrink-0 border-dashed border-2 border-gray-200 px-4 py-6 sm:px-6 lg:w-[32.2%] lg:border-dashed lg:border-dashed lg:pr-8 xl:pr-6">
//               <Docks 
//               item={docks}
//               />
//             </div>
//           </div>
//       </Layout>
//   );
// }

import {trucksData} from '@/data/trucks'
import {docksData} from '@/data/docks'

import React, {
  Dispatch,
  SetStateAction,
  useState,
  DragEvent,
  FormEvent,
} from "react";
import { FiPlus, FiTrash } from "react-icons/fi";
import { motion } from "framer-motion";
import { FaFire } from "react-icons/fa";

import Board from '@/components/Board'
import {DEFAULT_CARDS} from '@/data/cards.ts'

export default function CustomKanban () {
  return (
    <div className="h-screen w-full bg-neutral-900 text-neutral-50">
      <Board />
    </div>
  );
};

type ColumnType = "fully_charged" | "need_to_be_charged" | "docks";

type CardType = {
  title: string;
  id: string;
  column: ColumnType;
};