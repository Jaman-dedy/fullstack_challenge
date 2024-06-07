import React, {useState} from 'react';

import Column from '@/components/Column'
import {DEFAULT_CARDS} from '@/data/cards.ts'


const Board = () => {
    const [cards, setCards] = useState(DEFAULT_CARDS);
  
    return (
      <div className="flex h-full w-full gap-3 overflow-scroll p-12">
        <Column
          title="Fully charged"
          column="fully_charged"
          headingColor="text-neutral-500"
          cards={cards}
          setCards={setCards}
        />
        {/* <Column
          title="Charging"
          column="charging"
          headingColor="text-yellow-200"
          cards={cards}
          setCards={setCards}
        /> */}
        <Column
          title="Need to be charged"
          column="need_to_be_charged"
          headingColor="text-blue-200"
          cards={cards}
          setCards={setCards}
        />
        <Column
          title="Charging stations"
          column="docks"
          headingColor="text-emerald-200"
          cards={cards}
          setCards={setCards}
        />
      </div>
    );
  };

  export default Board