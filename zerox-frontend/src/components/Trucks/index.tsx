import {
    TruckIcon,
    Battery0Icon, Battery100Icon,
    Battery50Icon
} from '@heroicons/react/24/outline'
import './blink.css'

const items = [
    { title: 'ZEROX001-TN', description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX002-TN', description: 'Volvo FH16', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX003-TN', description: 'Scania R-series', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX004-TN', description: 'MAN TGX', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX005-TN', description: 'Renault T-series', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX006-TN', description: 'DAF XF', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX007-TN', description: 'Iveco S-Way', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX008-TN', description: 'Freightliner Cascadia', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX009-TN', description: 'Kenworth T680', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX010-TN', description: 'Peterbilt 579', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX011-TN', description: 'Western Star 5700', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX012-TN', description: 'Mack Anthem', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX013-TN', description: 'International LT', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX014-TN', description: 'Volvo VNL', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX015-TN', description: 'Freightliner Argosy', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX016-TN', description: 'Kenworth W990', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX017-TN', description: 'Peterbilt 389', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX018-TN', description: 'Western Star 4900', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX019-TN', description: 'Mack Pinnacle', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX020-TN', description: 'International ProStar', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX021-TN', description: 'Mercedes Atego', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX022-TN', description: 'Volvo FM', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX023-TN', description: 'Scania P-series', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX024-TN', description: 'MAN TGS', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX025-TN', description: 'Renault D-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX026-TN', description: 'DAF CF', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX027-TN', description: 'Iveco Trakker', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX028-TN', description: 'Freightliner M2', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX029-TN', description: 'Kenworth T800', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX030-TN', description: 'Peterbilt 567', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX031-TN', description: 'Western Star 4700', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX032-TN', description: 'Mack Granite', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX033-TN', description: 'International HV', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX034-TN', description: 'Volvo VHD', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX035-TN', description: 'Freightliner 122SD', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX036-TN', description: 'Kenworth C500', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX037-TN', description: 'Peterbilt 520', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX038-TN', description: 'Western Star 6900', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX039-TN', description: 'Mack TerraPro', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX040-TN', description: 'International WorkStar', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX041-TN', description: 'Mercedes Econic', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX042-TN', description: 'Volvo FE', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX043-TN', description: 'Scania G-series', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX044-TN', description: 'MAN TGL', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX045-TN', description: 'Renault C-series', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
    { title: 'ZEROX046-TN', description: 'DAF LF', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon },
    { title: 'ZEROX047-TN', description: 'Iveco Eurocargo', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery0Icon },
    { title: 'ZEROX048-TN', description: 'Freightliner 108SD', icon: TruckIcon, background: 'bg-gray-500', batStatus: Battery50Icon },
];

function classNames(...classes) {
    return classes.filter(Boolean).join(' ')
}

export default function Example() {
    return (
        <div>
            <h2 className="text-base font-semibold leading-6 text-gray-900">Autonomous Trucks</h2>
            <p className="mt-1 text-sm text-gray-500">
                Please check the battery status of the trucks here
            </p>
            <ul role="list" className="mt-6 grid grid-cols-1 gap-6 border-b border-t border-gray-200 py-6 sm:grid-cols-3">
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
                    </li>
                ))}
            </ul>
        </div>
    )
}
