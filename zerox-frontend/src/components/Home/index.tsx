import Layout from '@/components/Layout'
import Stats from '@/components/Stats'
import {trucksData} from '@/data/trucks'
import {docksData} from '@/data/docks'

import React, {
  Dispatch,
  SetStateAction,
  useState,
  DragEvent,
  FormEvent,
} from "react";
import { FiPlus, FiTrash } from "react-icons/fi";
import { motion } from "framer-motion";
import { FaFire } from "react-icons/fa";

import Board from '@/components/Board'

export default function CustomKanban () {
  return (
    <Layout>
       <div className="lg:mx-4 mx-2">
          <Stats/>
        </div>
      <Board />
    </Layout>
  );
};