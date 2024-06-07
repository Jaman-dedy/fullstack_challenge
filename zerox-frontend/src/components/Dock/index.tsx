import { useState, useEffect } from 'react';
import { BoltIcon, LockClosedIcon, LockOpenIcon } from '@heroicons/react/20/solid';
import './style.css';

interface DockProps {
    item: {
        title: string;
        description: string;
        icon: React.ComponentType<{ className: string }>;
        background: string;
        status: string;
        speed?: number;
        percentage?: number;
    }[];
    onDrop: (truckId: string, dockId: string) => void;
}

const Docks: React.FC<DockProps> = ({ item, onDrop }) => {
    const [items, setItems] = useState(item);

    useEffect(() => {
        const timer = setInterval(() => {
            setItems((prevItems) =>
                prevItems.map((item) => {
                    if (item.status === 'charging') {
                        const newPercentage = (item.percentage || 0) + (item.speed || 0);
                        return { ...item, percentage: newPercentage <= 100 ? newPercentage : 100 };
                    }
                    return item;
                })
            );
        }, 1000);

        return () => {
            clearInterval(timer);
        };
    }, []);


    return (
        <div>
            <h3 className="text-base font-semibold leading-6 text-gray-900">Charging stations</h3>
            <p className="mt-1 text-sm text-gray-500">
                Please monitor the charging stations here
            </p>
            <dl className="mt-5 grid grid-cols-1 gap-1 overflow-hidden rounded-lg bg-white shadow">
                {items.map((item) => (
                    <div
                        key={item.title}
                        className="px-4 py-6 sm:px-6 relative"
                    >
                        <dt className="text-base font-normal text-gray-900 relative z-10">{item.title}</dt>
                        <dd className="mt-1 flex items-baseline justify-between md:block lg:flex relative z-10">
                            <div className="flex items-baseline text-2xl font-semibold text-indigo-600">
                                {item.status === 'charging' ? `${item.percentage || 0}%` : 'Available'}
                                <span className="ml-2 text-sm font-medium text-gray-500">
                                    {item.status === 'charging' ? (
                                        <div className="flex items-center">
                                            <LockClosedIcon className="h-4 w-4 flex-shrink-0 text-yellow-500" />
                                            <svg className="h-4 w-4 ml-1 text-yellow-500 animate-spin" fill="none" viewBox="0 0 24 24">
                                                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                                                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                                            </svg>
                                        </div>
                                    ) : (
                                        <LockOpenIcon className="h-4 w-4 text-gray-500" />
                                    )}
                                </span>
                            </div>
                            <div className="relative inline-flex items-center justify-center rounded-full p-2 text-yellow-500 md:mt-2 lg:mt-0">
                                <item.icon
                                    className="h-6 w-6 relative z-10 animate-breathe"
                                    aria-hidden="true"
                                />
                            </div>
                        </dd>
                        <div className="absolute inset-0 rounded-lg overflow-hidden">
                            <div className="absolute inset-0 flex justify-center items-center pointer-events-none">
                                <div className="w-4 h-2 bg-gray-300 rounded-full"></div>
                            </div>
                            <div className="absolute inset-0 bg-gray-200 rounded-lg"></div>
                            {item.status === 'charging' && (
                                <div
                                    className="absolute inset-0 bg-green-500 rounded-lg"
                                    style={{ width: `${item.percentage || 0}%`, transition: 'width 1s ease-in-out' }}
                                ></div>
                            )}
                        </div>
                    </div>
                ))}
            </dl>
        </div>
    );
};

export default Docks;