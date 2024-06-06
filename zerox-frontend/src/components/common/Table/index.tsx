import { FC } from 'react';

type TableHeader = {
  key: string;
  label: string;
};

type TableItem = {
  [key: string]: any;
};

type TableProps = {
  headers: TableHeader[];
  items: TableItem[];
};

export default function Table({ headers, items }: TableProps) {
  const renderCell = (item: TableItem, key: string) => {
    const value = item[key];

    if (key === 'icon') {
      return (
        <div className="flex items-center">
          <div
            className={`flex-shrink-0 h-10 w-10 ${item.background} rounded-md flex items-center justify-center`}
          >
            {item.icon && <item.icon className="h-6 w-6 text-white" aria-hidden="true" />}
          </div>
        </div>
      );
    } else if (key === 'batStatus') {
      return item.batStatus && <item.batStatus className="h-5 w-5 text-green-400" aria-hidden="true" />;
    } else if (key === 'status') {
      return (
        <span
          className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
            value === 'Available' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
          }`}
        >
          {value}
        </span>
      );
    } else {
      return <div className="text-sm text-gray-900">{value}</div>;
    }
  };

  return (
    <table className="min-w-full divide-y divide-gray-200">
      <thead>
        <tr>
          {headers.map((header) => (
            <th
              key={header.key}
              className="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              {header.label}
            </th>
          ))}
        </tr>
      </thead>
      <tbody className="bg-white divide-y divide-gray-200">
        {items.map((item, index) => (
          <tr key={index}>
            {headers.map((header) => (
              <td key={header.key} className="px-6 py-4 whitespace-nowrap">
                {renderCell(item, header.key)}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
}