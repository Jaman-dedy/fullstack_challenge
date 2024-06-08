import {
    TruckIcon,
    Battery0Icon, Battery100Icon,
    Battery50Icon
} from '@heroicons/react/24/outline'

export const DEFAULT_TRUCKS: CardType[] = [
    // by default all trucks need to be charged
    { title: "ZEROX001-TN", id: "1", description: 'Mercedes Actros', icon: TruckIcon, background: 'bg-green-500', batStatus: Battery100Icon, column: "need_to_be_charged" },
    { title: "SOX compliance checklist", id: "2", column: "need_to_be_charged" },
    { title: "[SPIKE] Migrate to Azure", id: "3", column: "need_to_be_charged" },
    { title: "Document Notifications service", id: "4", column: "need_to_be_charged" },
  
    {
      title: "Refactor context providers to use Zustand",
      id: "8",
      column: "need_to_be_charged",
    },
    { title: "Add logging to daily CRON", id: "9", column: "need_to_be_charged" },
    {
      title: "Research DB options for new microservice",
      id: "5",
      column: "need_to_be_charged",
    },
    { title: "Postmortem for outage", id: "6", column: "need_to_be_charged" },
    { title: "Sync with product on Q3 roadmap", id: "7", column: "need_to_be_charged" },
    {
      title: "Set up DD dashboards for Lambda listener",
      id: "10",
      column: "need_to_be_charged",
    },
    {
      title: "Set up DD dashboards for Lambda listener",
      id: "11",
      column: "need_to_be_charged",
    },
  ];