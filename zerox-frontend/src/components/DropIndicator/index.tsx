import React from 'react';

type DropIndicatorProps = {
    beforeId: string | null;
    column: string;
  };
  
  const DropIndicator = ({ beforeId, column }: DropIndicatorProps) => {
    if (column === "fully_charged") {
      return null;
    }
    return (
      <div
        data-before={beforeId || "-1"}
        data-column={column}
        className="my-0.5 h-0.5 w-full opacity-0"
      />
    );
  };

  export default DropIndicator