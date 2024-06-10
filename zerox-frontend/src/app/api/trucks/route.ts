import { NextRequest, NextResponse } from 'next/server';
import { retrieveTrucks, updateTruck } from '@/helpers/trucks';

export async function GET() {
  try {
    const trucks = retrieveTrucks();
    return NextResponse.json(
      {
        trucks,
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        error: 'Something went wrong. Please try again later.',
      },
      { status: 500 }
    );
  }
}

export async function PUT(req: NextRequest, res: NextResponse) {
  try {
    const truck = await req.json();
    const updatedTrucks = updateTruck(truck);
    return NextResponse.json(
      {
        trucks: updatedTrucks,
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        error: 'Something went wrong. Please try again later.',
      },
      { status: 500 }
    );
  }
}
