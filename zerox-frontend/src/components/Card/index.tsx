import React from 'react';
import { motion } from "framer-motion";
import { Battery0Icon, Battery100Icon, Battery50Icon } from '@heroicons/react/24/outline';

import { CardType } from '@/types';

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

type CardProps = CardType & {
  handleDragStart: Function;
};

const Card = ({ title, id, column, handleDragStart, background, icon, batStatus, dockId, progress }: CardProps) => {
  const isDraggable = column === "need_to_be_charged";

  let truckIconBackground = "";
  let batteryIcon = null;

  if (column === "need_to_be_charged") {
    truckIconBackground = "bg-gray-500";
    batteryIcon = <Battery0Icon className="h-5 w-5 flex-shrink-0 text-red-500 animate-pulse" aria-hidden="true" />;
  } else if (column === "fully_charged") {
    truckIconBackground = "bg-green-500";
    batteryIcon = <Battery100Icon className="h-5 w-5 flex-shrink-0 text-green-500" aria-hidden="true" />;
  } else if (column === "docks") {
    truckIconBackground = "bg-yellow-500";
    batteryIcon = <Battery50Icon className="h-5 w-5 flex-shrink-0 text-yellow-500" aria-hidden="true" />;
  }

  return (
    <>
      {isDraggable ? (
        <motion.div
          layout
          layoutId={id}
          draggable="true"
          onDragStart={(e) => handleDragStart(e, { title, id, column, dockId })}
          className="relative mb-3 flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 hover:bg-gray-200 cursor-grab active:cursor-grabbing border border-gray-200 text-gray-500"
        >
          <div
            className={classNames(
              truckIconBackground,
              'flex h-20 w-20 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {icon && React.createElement(icon, { className: "h-6 w-6 text-white", "aria-hidden": "true" })}
          </div>
          <div>
            <p className="text-sm text-gray-900">{title}</p>
            <div className="flex items-center">
              {batteryIcon}
            </div>
          </div>
        </motion.div>
      ) : (
        <div
          className={`relative flex items-center space-x-4 rounded-xl p-2 focus-within:ring-2 focus-within:ring-indigo-500 ${
            column === "docks"
              ? "bg-emerald-500 text-gray-500"
              : "hover:bg-gray-500 text-gray-500 cursor-not-allowed border border-gray-200"
          } ${column === "fully_charged" ? "mb-2" : ""}`}
        >
          <div
            className={classNames(
              truckIconBackground,
              'flex h-20 w-20 flex-shrink-0 items-center justify-center rounded-lg'
            )}
          >
            {icon && React.createElement(icon, { className: "h-6 w-6 text-white", "aria-hidden": "true" })}
          </div>
          <div>
            <p className="text-sm text-gray-500">{title}</p>
            <div className="flex items-center">
              {batteryIcon}
            </div>
          </div>
          {column === "docks" && (
            <div className="absolute bottom-0 left-0 right-0 h-1 bg-gray-200">
              <div
                className="h-full bg-yellow-500 transition-all duration-500 ease-linear"
                style={{ width: `${progress}%` }}
              />
            </div>
          )}
        </div>
      )}
    </>
  );
};

export default Card;