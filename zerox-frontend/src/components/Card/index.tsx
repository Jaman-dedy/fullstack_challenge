import React from 'react';
import { motion } from "framer-motion";
import { Battery0Icon, Battery100Icon, Battery50Icon } from '@heroicons/react/24/outline';

import DropIndicator from '@/components/DropIndicator';
import { CardType } from '@/types';

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

type CardProps = CardType & {
  handleDragStart: Function;
};

const Card = ({ title, id, column, handleDragStart, background, icon, batStatus }: CardProps) => {
  const isDraggable = column === "need_to_be_charged";

  return (
    <>
      <DropIndicator beforeId={id} column={column} />
      {isDraggable ? (
        <motion.div
          layout
          layoutId={id}
          draggable="true"
          onDragStart={(e) => handleDragStart(e, { title, id, column })}
          className="relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-grab active:cursor-grabbing border border-gray-200 text-gray-900"
        >
          <div
            className={classNames(
              background,
              'flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {icon && React.createElement(icon, { className: "h-6 w-6 text-white", "aria-hidden": "true" })}
          </div>
          <div>
            <p className="text-sm text-gray-900">{title}</p>
            <div className="flex items-center">
              {batStatus === Battery100Icon ? (
                <Battery100Icon className="h-5 w-5 flex-shrink-0 text-green-500" aria-hidden="true" />
              ) : batStatus === Battery0Icon ? (
                <Battery0Icon className="h-5 w-5 flex-shrink-0 text-red-500 animate-pulse" aria-hidden="true" />
              ) : (
                <>
                  <Battery50Icon className="h-5 w-5 flex-shrink-0 text-yellow-500" aria-hidden="true" />
                  <svg className="h-4 w-4 ml-1 text-yellow-500 animate-spin" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                  </svg>
                </>
              )}
            </div>
          </div>
        </motion.div>
      ) : (
        <div
          className={`relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-500 cursor-not-allowed border border-neutral-700 bg-neutral-800 ${
            column === "fully_charged" ? "mb-2" : ""
          }`}
        >
          <div
            className={classNames(
              background,
              'flex h-16 w-16 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {icon && React.createElement(icon, { className: "h-6 w-6 text-white", "aria-hidden": "true" })}
          </div>
          <div>
            <p className="text-sm text-neutral-100">{title}</p>
            <div className="flex items-center">
              {batStatus === Battery100Icon ? (
                <Battery100Icon className="h-5 w-5 flex-shrink-0 text-green-500" aria-hidden="true" />
              ) : batStatus === Battery0Icon ? (
                <Battery0Icon className="h-5 w-5 flex-shrink-0 text-red-500 animate-pulse" aria-hidden="true" />
              ) : (
                <>
                  <Battery50Icon className="h-5 w-5 flex-shrink-0 text-yellow-500" aria-hidden="true" />
                  <svg className="h-4 w-4 ml-1 text-yellow-500 animate-spin" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                  </svg>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Card;