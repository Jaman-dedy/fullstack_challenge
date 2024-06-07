import React from 'react';
import { motion } from "framer-motion";

import DropIndicator from '@/components/DropIndicator'

type CardProps = CardType & {
    handleDragStart: Function;
  };
  
  const Card = ({ title, id, column, handleDragStart }: CardProps) => {
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
          className="cursor-grab rounded border border-neutral-700 bg-neutral-800 p-3 active:cursor-grabbing"
        >
          <p className="text-sm text-neutral-100">{title}</p>
        </motion.div> 
        ): (
          <div className={`rounded border border-neutral-700 bg-neutral-800 p-3 cursor-not-allowed ${
            column === "fully_charged" ? "mb-2" : ""
          }`}>
            <p className="text-sm text-neutral-100">{title}</p>
          </div>
        )}
        
      </>
    );
  };

  export default Card;