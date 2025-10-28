import React, { useEffect, useState } from "react";
import { useAuth } from "../contexts/AuthContext";
import { getAllUsers, createUser, updateUser, deleteUser } from "../services/userService";
import UserForm from "../components/UserForm";
import UserTable from "../components/UserTable";

const Users = () => {
  const { user } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [editingUser, setEditingUser] = useState(null);

  const fetchUsers = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await getAllUsers();
      setUsers(res.data);
    } catch (err) {
      setError("Falha ao carregar usuários");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user?.role === "admin") fetchUsers();
    else setError("Você não tem permissão para acessar esta página.");
  }, [user]);

  const handleSave = async (userData) => {
    try {
      const { id, ...payload } = editingUser ? { ...userData, id: editingUser.id } : userData;
      if (editingUser) await updateUser(editingUser.id, payload);
      else await createUser(payload);
      setEditingUser(null);
      fetchUsers();
    } catch (err) {
      console.error(err);
      setError("Erro ao salvar usuário");
    }
  };

  const handleEdit = (u) => setEditingUser(u);
  const handleCancel = () => setEditingUser(null);
  const handleDelete = async (id) => {
    if (!window.confirm("Deseja realmente deletar este usuário?")) return;
    try {
      await deleteUser(id);
      fetchUsers();
    } catch (err) {
      console.error(err);
      setError("Erro ao deletar usuário");
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6 text-center">Gerenciar Usuários</h1>

      <UserForm
        userToEdit={editingUser}
        onSave={handleSave}
        onCancel={handleCancel}
      />

      {loading ? (
        <div className="text-center">Carregando...</div>
      ) : error ? (
        <div className="text-center text-red-500 font-semibold">{error}</div>
      ) : (
        <UserTable
          users={users}
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      )}
    </div>
  );
};

export default Users;