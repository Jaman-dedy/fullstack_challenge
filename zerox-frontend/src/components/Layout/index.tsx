import { ReactNode, useState } from 'react';
import Sidebar from '@/components/common/Sidebar';
import Header from '@/components/common/Header';

type LayoutProps = {
  children: ReactNode;
};

export default function Layout({ children}: LayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  return (
    <div>
      <Sidebar sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} />
      <div className="lg:pl-20">
        <Header setSidebarOpen={setSidebarOpen} />
        <main className="py-3 bg-white">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">{children}</div>
        </main>
      </div>
    </div>
  );
}