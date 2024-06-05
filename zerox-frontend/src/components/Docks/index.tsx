import {
    LockClosedIcon,
    LockOpenIcon,
    Battery100Icon,
    BoltIcon,
} from '@heroicons/react/24/outline'

const items = [
    { title: 'Dock 1', description: 'Available', icon: BoltIcon, background: 'bg-gray-500', status: 'free' },
    { title: 'Dock 2', description: 'Charging - 1h 30m remaining', icon: BoltIcon, background: 'bg-yellow-500', status: 'charging' },
    { title: 'Dock 3', description: 'Fully Charged', icon: BoltIcon, background: 'bg-green-500', status: 'charged' },
    { title: 'Dock 4', description: 'Available', icon: BoltIcon, background: 'bg-gray-500', status: 'free' },
    { title: 'Dock 5', description: 'Charging - 45m remaining', icon: BoltIcon, background: 'bg-yellow-500', status: 'charging' },
    { title: 'Dock 6', description: 'Available', icon: BoltIcon, background: 'bg-gray-500', status: 'free' },
    { title: 'Dock 7', description: 'Fully Charged', icon: BoltIcon, background: 'bg-green-500', status: 'charged' },
    { title: 'Dock 8', description: 'Available', icon: BoltIcon, background: 'bg-gray-500', status: 'free' },
    { title: 'Dock 9', description: 'Charging - 2h remaining', icon: BoltIcon, background: 'bg-yellow-500', status: 'charging' },
    { title: 'Dock 10', description: 'Available', icon: BoltIcon, background: 'bg-gray-500', status: 'free' },
];

function classNames(...classes) {
    return classes.filter(Boolean).join(' ')
}

export default function Example() {
    return (
        <div>
            <h2 className="text-base font-semibold leading-6 text-gray-900">Charging stations</h2>
            <p className="mt-1 text-sm text-gray-500">
                Please check the status of the charging stations here
            </p>
            <ul role="list" className="mt-6 grid grid-cols-1 gap-6 border-b border-t border-gray-200 py-6 sm:grid-cols-1">
                {items.map((item, itemIdx) => (
                    <li key={itemIdx} className="flow-root">
                        <div className="relative -m-2 flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-50">
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
                                    {item.status === 'charging' && (
                                        <div className="flex">
                                            <LockClosedIcon className="h-4 w-5 flex-shrink-0 text-yellow-500 " />
                                            <svg className="h-4 w-4 ml-1 text-yellow-500 animate-spin" fill="none" viewBox="0 0 24 24">
                                                <circle className="opacity-25 mt-1" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                                                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                                            </svg>
                                        </div>
                                    )}
                                    {item.status === 'charged' && (
                                        <div className="">
                                            <Battery100Icon className="h-5 w-5 text-green-500 animate-pulse" />
                                        </div>
                                    )}
                                    {item.status === 'free' && (
                                        <div className="">
                                            <LockOpenIcon className="h-4 w-4 text-gray-500" />
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    </li>
                ))}
            </ul>
        </div>
    )
}
