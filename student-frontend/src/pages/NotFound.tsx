import React from "react";
import { Link } from "react-router-dom";

const NotFoundPage: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center">
      <div className="max-w-md mx-auto px-4 py-8 bg-white shadow-md rounded-lg">
        <div className="text-center">
          <div className="text-5xl font-bold text-gray-300">404</div>
          <h1 className="mt-4 text-xl font-bold text-gray-900">
            Page not found
          </h1>
          <p className="mt-2 text-gray-600">
            Trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.
          </p>
          <Link
            to="/"
            className="mt-6 inline-block px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-lg"
          >
            Quay về trang chủ
          </Link>
        </div>
      </div>
    </div>
  );
};

export default NotFoundPage;
