import React, { useEffect, useState } from "react";
import ClientForm from "../components/ClientForm";
import ClientTable from "../components/ClientTable";
import api from "../services/api";

const Clients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingClient, setEditingClient] = useState(null);

  const fetchClients = async () => {
    setLoading(true);
    try {
      const res = await api.get("/clients", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      });
      setClients(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchClients();
  }, []);

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6 text-center">Gerenciar Clientes</h1>

      <ClientForm
        editingClient={editingClient}
        setEditingClient={setEditingClient}
        fetchClients={fetchClients}
      />

      {loading ? (
        <div className="text-center">Carregando...</div>
      ) : (
        <ClientTable
          clients={clients}
          setEditingClient={setEditingClient}
          fetchClients={fetchClients}
        />
      )}
    </div>
  );
};

export default Clients;