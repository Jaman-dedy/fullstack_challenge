export type ColumnType = "fully_charged" | "need_to_be_charged" | "docks";

export type CardType = {
  title: string;
  id: string;
  column: ColumnType;
};