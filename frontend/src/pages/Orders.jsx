import React, { useEffect, useState } from "react";
import OrderForm from "../components/OrderForm";
import OrderTable from "../components/OrderTable";
import api from "../services/api";

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingOrder, setEditingOrder] = useState(null);

  const fetchOrders = async () => {
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

  return (
    <div className="p-6 max-w-5xl mx-auto">
      <h1 className="text-3xl font-bold mb-6 text-center">Gerenciar Pedidos</h1>

      <OrderForm onOrderCreated={fetchOrders} />

      {loading ? (
        <div>Carregando...</div>
      ) : (
        <OrderTable
          orders={orders}
          setEditingOrder={setEditingOrder}
          fetchOrders={fetchOrders}
        />
      )}
    </div>
  );
};

export default Orders;