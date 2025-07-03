import React from "react";
import { Outlet } from "react-router-dom";
import MainLayout from "./layouts/MainLayout";

const App: React.FC = () => {
  return (
    <MainLayout>
      <Outlet />
    </MainLayout>
  );
};

export default App;
