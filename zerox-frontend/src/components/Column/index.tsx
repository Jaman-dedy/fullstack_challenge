import React, { useState, useEffect } from 'react';
import Card from '@/components/Card';
import { ColumnType, CardType } from '@/types';

type ColumnProps = {
  title: string;
  headingColor: string;
  cards: CardType[];
  column: ColumnType;
  setCards: React.Dispatch<React.SetStateAction<CardType[]>>;
  dockCounts?: number;
  onTruckCountChange?: (count: number) => void;
  onChargingStationCountChange?: (count: number) => void;
};

const Column = ({
  title,
  headingColor,
  cards,
  column,
  setCards,
  dockCounts = 10,
  onTruckCountChange,
  onChargingStationCountChange,
}: ColumnProps) => {
  const [active, setActive] = useState(false);
  const [dockCount, setDockCount] = useState(dockCounts);

  const handleDragStart = (e: DragEvent, card: CardType) => {
    e.dataTransfer.setData("cardId", card.id);
  };

  // useEffect(() => {
  //   const chargingTrucks = cards.filter((card) => card.column === 'docks');
  //   setDockCount(dockCounts - chargingTrucks.length);
  // }, [cards, dockCounts]);

  useEffect(() => {
    const chargingTrucks = cards.filter((card) => card.column === 'docks');
    setDockCount(dockCounts - chargingTrucks.length);

    if (onChargingStationCountChange) {
      onChargingStationCountChange(dockCounts - chargingTrucks.length);
    }
  }, [cards, dockCounts, onChargingStationCountChange]);

  useEffect(() => {
    if (onTruckCountChange) {
      onTruckCountChange(filteredCards.length);
    }
  }, [cards, column, onTruckCountChange]);

  const handleDragEnd = (e: DragEvent) => {
    setActive(false);
  };

  const handleDragOver = (e: DragEvent, dockId?: string) => {
    e.preventDefault();
    if (dockId) {
      const dockElement = document.querySelector(`[data-dock-id="${dockId}"]`);
      if (dockElement) {
        dockElement.classList.add("bg-white-500", "text-gray-500");
      }
    } else {
      setActive(true);
    }
  };

  const handleDragLeave = (e: DragEvent) => {
    e.preventDefault();
    const dockElement = e.target as HTMLElement;
    dockElement.classList.remove("bg-emerald-200", "text-white");
    setActive(false);
  };

  const handleDockDrop = (e: DragEvent, dockId: string) => {
    e.preventDefault();
    const cardId = e.dataTransfer.getData("cardId");

    setCards((prevCards) =>
      prevCards.map((card) =>
        card.id === cardId ? { ...card, column: "docks", dockId, progress: 0 } : card
      )
    );

    let progress = 0;
    const chargingInterval = setInterval(() => {
      progress += 1;
      if (progress <= 100) {
        setCards((prevCards) =>
          prevCards.map((card) =>
            card.id === cardId ? { ...card, progress } : card
          )
        );
      } else {
        clearInterval(chargingInterval);

        setCards((prevCards) =>
          prevCards.map((card) =>
            card.id === cardId ? { ...card, column: "fully_charged", dockId: null, progress: 0 } : card
          )
        );

        setTimeout(() => {
          setCards((prevCards) =>
            prevCards.map((card) =>
              card.id === cardId ? { ...card, column: "need_to_be_charged" } : card
            )
          );
        }, 5000);
      }
    }, 100);
  };

  const filteredCards = cards.filter((c) => c.column === column);

  const dockCards = Array.from({ length: dockCounts }, (_, index) => (
    <div
      key={`dock-${index}`}
      data-dock-id={`dock-${index}`}
      onDragOver={(e) => handleDragOver(e, `dock-${index}`)}
      onDragLeave={handleDragLeave}
      onDrop={(e) => handleDockDrop(e, `dock-${index}`)}
      className="h-24 mb-6 rounded-xl border-2 border-dashed border-green-200 flex items-center justify-center text-gray-500"
    >
      {cards.find((card) => card.dockId === `dock-${index}`) ? (
        <Card
          key={cards.find((card) => card.dockId === `dock-${index}`).id}
          {...cards.find((card) => card.dockId === `dock-${index}`)}
          handleDragStart={() => {}}
        />
      ) : (
        `Dock ${index + 1}`
      )}
    </div>
  ));

  return (
    <div className="w-56 shrink-0">
      <div className="mb-3 flex items-center justify-between">
        <h3 className={`font-medium text-gray-500`}>{title}</h3>
      </div>
      <div
        onDrop={handleDragEnd}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        className={`h-full w-full transition-colors ${
          active ? "bg-gray-200" : "bg-neutral-800/0"
        }`}
      >
        {column === "docks" ? (
          dockCards
        ) : (
          filteredCards.map((c) => (
            <Card key={c.id} {...c} handleDragStart={handleDragStart} />
          ))
        )}
      </div>
    </div>
  );
};

export default Column;