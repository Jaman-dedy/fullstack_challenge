import React, { useState } from 'react';
import {
    TruckIcon,
    Battery0Icon, Battery100Icon,
    Battery50Icon
} from '@heroicons/react/24/outline'
import { Reorder } from 'framer-motion';
import Truck from '@/components/common/Truck'
import DraggableTruck from '@/components/common/DraggableTruck'
import {trucksData} from '@/data/trucks'
import {docksData} from '@/data/docks'
import './blink.css'

function classNames(...classes) {
    return classes.filter(Boolean).join(' ')
}

interface TruckProps {
    item: {
        title: string;
        description: string;
        icon: React.ComponentType<{ className: string }>;
        background: string;
        batStatus: React.ComponentType<{ className: string }>;
    }[];
}

const Trucks: React.FC = ({ }) => {
    const [fullyChargedItems, setFullyChargedItems] = useState(trucksData.filter(trucksData => trucksData.batStatus === Battery100Icon));
    const [chargingItems, setChargingItems] = useState(trucksData.filter(trucksData => trucksData.batStatus === Battery50Icon));
    const [needChargeItems, setNeedChargeItems] = useState(trucksData.filter(trucksData => trucksData.batStatus === Battery0Icon));

    return (
        <div>
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
                <div>
                    <div className="mb-4 text-sm text-gray-500">Trucks charged</div>
                    <div className="space-y-4">
                        {fullyChargedItems.map((item, index) => (
                            <Truck key={index} item={item} />
                        ))}
                    </div>
                </div>
                {/* <div>
                    <div className="mb-4 text-sm text-gray-500">Trucks on charge</div>
                    <div className="space-y-4">
                        {chargingItems.map((item, index) => (
                            <Truck key={index} item={item} />
                        ))}
                    </div>
                </div> */}
                <div>
                    <div className="mb-4 text-sm text-gray-500">Trucks to charge</div>

                        {needChargeItems.map((item, index) => (
                            <DraggableTruck key={index} id={index} item={item}/>
                        ))}
                </div>
            </div>
        </div>
    )
}

export default Trucks