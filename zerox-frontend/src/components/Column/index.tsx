import React, {useState} from 'react';

import DropIndicator from '@/components/DropIndicator'
import Card from '@/components/Card'
import {ColumnType, CardType} from '@/types'

type ColumnProps = {
    title: string;
    headingColor: string;
    cards: CardType[];
    column: ColumnType;
    setCards: Dispatch<SetStateAction<CardType[]>>;
  };
  
  const Column = ({
    title,
    headingColor,
    cards,
    column,
    setCards,
  }: ColumnProps) => {
    const [active, setActive] = useState(false);
    const [chargingItems, setChargingItems] = useState<string[]>([]);
  
    const handleDragStart = (e: DragEvent, card: CardType) => {
      e.dataTransfer.setData("cardId", card.id);
    };
  
    const handleDragEnd = (e: DragEvent) => {
      const cardId = e.dataTransfer.getData("cardId");
  
      setActive(false);
      clearHighlights();
  
      const indicators = getIndicators();
      const { element } = getNearestIndicator(e, indicators);
  
      const before = element.dataset.before || "-1";
  
      if (column !== "docks") {
        alert("Cards can only be dropped on the Charging stations column.");
        return;
      }
  
      if (before !== cardId) {
        let copy = [...cards];
  
        let cardToTransfer = copy.find((c) => c.id === cardId);
        if (!cardToTransfer) return;
        cardToTransfer = { ...cardToTransfer, column };
  
        copy = copy.filter((c) => c.id !== cardId);
  
        const moveToBack = before === "-1";
  
        if (moveToBack) {
          copy.push(cardToTransfer);
        } else {
          const insertAtIndex = copy.findIndex((el) => el.id === before);
          if (insertAtIndex === undefined) return;
  
          copy.splice(insertAtIndex, 0, cardToTransfer);
        }
  
        setCards(copy);
  
        // Show an alert when a card is dropped on the "Charging stations" column
      const dockNumber = copy.findIndex((c) => c.id === cardId) + 1;
      // alert(`Item ${cardId} has started charging on dock ${dockNumber}`);
  
      // Add the item to the charging items state
      setChargingItems((prevItems) => [...prevItems, cardId]);
  
        // Start a timer to move the card to the "Fully charged" column after 5 seconds
        setTimeout(() => {
          setChargingItems((prevItems) => prevItems.filter((id) => id !== cardId));
  
          setCards((prevCards) => {
            const updatedCards = prevCards.map((c) => {
              if (c.id === cardId) {
                return { ...c, column: "fully_charged" };
              }
              return c;
            });
            return updatedCards;
          });
          // alert(`Item ${cardId} is fully charged`);
         // Set a timeout to move the item to the "Need to be charged" column after 10 seconds
         setTimeout(() => {
          setCards((prevCards) => {
            const updatedCards = prevCards.map((c) => {
              if (c.id === cardId) {
                return { ...c, column: "need_to_be_charged" };
              }
              return c;
            });
            return updatedCards;
          });
        }, 10000); 
        }, 10000);
  
      }
    };
  
    const handleDragOver = (e: DragEvent) => {
      e.preventDefault();
      highlightIndicator(e);
  
      setActive(true);
    };
  
    const clearHighlights = (els?: HTMLElement[]) => {
      const indicators = els || getIndicators();
  
      indicators.forEach((i) => {
        i.style.opacity = "0";
      });
    };
  
    const highlightIndicator = (e: DragEvent) => {
      const indicators = getIndicators();
  
      clearHighlights(indicators);
  
      const el = getNearestIndicator(e, indicators);
  
      el.element.style.opacity = "1";
    };
  
    const getNearestIndicator = (e: DragEvent, indicators: HTMLElement[]) => {
      const DISTANCE_OFFSET = 50;
  
      const el = indicators.reduce(
        (closest, child) => {
          const box = child.getBoundingClientRect();
  
          const offset = e.clientY - (box.top + DISTANCE_OFFSET);
  
          if (offset < 0 && offset > closest.offset) {
            return { offset: offset, element: child };
          } else {
            return closest;
          }
        },
        {
          offset: Number.NEGATIVE_INFINITY,
          element: indicators[indicators.length - 1],
        }
      );
  
      return el;
    };
  
    const getIndicators = () => {
      return Array.from(
        document.querySelectorAll(
          `[data-column="${column}"]`
        ) as unknown as HTMLElement[]
      );
    };
  
    const handleDragLeave = () => {
      clearHighlights();
      setActive(false);
    };
  
    const filteredCards = cards.filter((c) => c.column === column);
  
    return (
      <div className="w-56 shrink-0">
        <div className="mb-3 flex items-center justify-between">
          <h3 className={`font-medium ${headingColor}`}>{title}</h3>
          <span className="rounded text-sm text-neutral-400">
            {filteredCards.length}
          </span>
        </div>
        <div
          onDrop={handleDragEnd}
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          className={`h-full w-full transition-colors ${
            active ? "bg-neutral-800/50" : "bg-neutral-800/0"
          }`}
        >
          {filteredCards.map((c) => {
            return <Card key={c.id} {...c} handleDragStart={handleDragStart} />;
          })}
          <DropIndicator beforeId={null} column={column} />
        </div>
      </div>
    );
  };

  export default Column;