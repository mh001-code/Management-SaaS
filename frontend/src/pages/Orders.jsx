import React, { useEffect, useState, useRef } from "react";
import OrderForm from "../components/OrderForm";
import OrderTable from "../components/OrderTable";
import api from "../services/api";

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingOrder, setEditingOrder] = useState(null);

  const formRef = useRef(null);

  const fetchOrders = async () => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const res = await api.get("/orders", {
        headers: { Authorization: `Bearer ${token}` },
      });
      setOrders(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  const handleEdit = (order) => {
    setEditingOrder(order);
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleCancelEdit = () => setEditingOrder(null);

  return (
    <div className="p-4 md:p-6 bg-gray-100 min-h-screen max-w-full md:max-w-6xl mx-auto">
      <h1 className="text-2xl md:text-3xl font-bold mb-6 text-center">
        Gerenciar Pedidos
      </h1>

      <div ref={formRef}>
        <OrderForm
          onOrderCreated={fetchOrders}
          editingOrder={editingOrder}
          onCancel={handleCancelEdit}
        />
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-10">
          <div className="w-10 h-10 border-4 border-blue-500 border-dashed rounded-full animate-spin"></div>
        </div>
      ) : (
        <OrderTable
          orders={orders}
          setEditingOrder={handleEdit}
          fetchOrders={fetchOrders}
        />
      )}
    </div>
  );
};

export default Orders;