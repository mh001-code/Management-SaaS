import React, { useEffect, useState, useRef } from "react";
import ClientForm from "../components/ClientForm";
import ClientTable from "../components/ClientTable";
import api from "../services/api";

const Clients = () => {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingClient, setEditingClient] = useState(null);

  // Referência para o formulário
  const formRef = useRef(null);

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

  const handleEditClient = (client) => {
    setEditingClient(client);

    // Scroll para o topo do formulário
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  return (
    <div className="p-4 md:p-6 bg-gray-100 min-h-screen max-w-full md:max-w-6xl mx-auto">
      <h1 className="text-2xl md:text-3xl font-bold mb-6 text-center">
        Gerenciar Clientes
      </h1>

      {/* Adiciona a referência aqui */}
      <div ref={formRef}>
        <ClientForm
          editingClient={editingClient}
          setEditingClient={setEditingClient}
          fetchClients={fetchClients}
        />
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-10">
          <div className="w-10 h-10 border-4 border-blue-500 border-dashed rounded-full animate-spin"></div>
        </div>
      ) : clients.length > 0 ? (
        <ClientTable
          clients={clients}
          setEditingClient={handleEditClient}
          fetchClients={fetchClients}
        />
      ) : (
        <p className="text-center text-gray-500 py-6">Nenhum cliente cadastrado.</p>
      )}
    </div>
  );
};

export default Clients;