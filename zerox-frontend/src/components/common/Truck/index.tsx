import React from 'react';
import { Reorder } from 'framer-motion';
import {
    TruckIcon,
    Battery0Icon, Battery100Icon,
    Battery50Icon
} from '@heroicons/react/24/outline'

function classNames(...classes) {
    return classes.filter(Boolean).join(' ')
}

interface TruckProps {
    item: any;
}

const Truck: React.FC<TruckProps> = ({ item }) => {
    return (
        <div
            className="relative -m-2 flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-50"
        >
            <div
                className={classNames(
                    item.background,
                    'flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg'
                )}
            >
                <item.icon className="h-6 w-6 text-white" aria-hidden="true" />
            </div>
            <div>
                <h3 className="text-sm font-medium text-gray-900">
                    <a href="#" className="focus:outline-none">
                        <span className="absolute inset-0" aria-hidden="true" />
                        <span>{item.title}</span>
                        <span aria-hidden="true"> &rarr;</span>
                    </a>
                </h3>
                <p className="mt-1 text-sm text-gray-500">{item.description}</p>
                <div className="flex items-center">
                    {item.batStatus === Battery100Icon ? (
                        <item.batStatus className="h-5 w-5 flex-shrink-0 text-green-500" aria-hidden="true" />
                    ) : item.batStatus === Battery0Icon ? (
                        <item.batStatus className="h-5 w-5 flex-shrink-0 text-red-500 animate-pulse" aria-hidden="true" />
                    ) : (
                        <>
                            <item.batStatus className="h-5 w-5 flex-shrink-0 text-yellow-500" aria-hidden="true" />
                            <svg className="h-4 w-4 ml-1 text-yellow-500 animate-spin" fill="none" viewBox="0 0 24 24">
                                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                            </svg>
                        </>
                    )}
                </div>
            </div>
        </div>
    )
}

export default Truck