import React, { useState, useEffect } from "react";

const UserForm = ({ userToEdit, onSave, onCancel }) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("user");

  useEffect(() => {
    if (userToEdit) {
      setName(userToEdit.name);
      setEmail(userToEdit.email);
      setRole(userToEdit.role);
      setPassword("");
    } else {
      setName("");
      setEmail("");
      setRole("user");
      setPassword("");
    }
  }, [userToEdit]);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave({ name, email, password: password || undefined, role });
    setPassword("");
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="mb-6 p-4 md:p-6 bg-white rounded shadow grid grid-cols-1 sm:grid-cols-2 gap-4"
    >
      <h2 className="text-lg font-semibold sm:col-span-2">
        {userToEdit ? "Editar Usuário" : "Criar Usuário"}
      </h2>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Nome:</label>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
          className="border p-2 rounded w-full"
        />
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Email:</label>
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          className="border p-2 rounded w-full"
        />
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Senha:</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder={userToEdit ? "Deixe em branco para não alterar" : ""}
          className="border p-2 rounded w-full"
          required={!userToEdit}
        />
      </div>

      <div className="flex flex-col">
        <label className="font-medium mb-1">Função:</label>
        <select
          value={role}
          onChange={(e) => setRole(e.target.value)}
          className="border p-2 rounded w-full"
        >
          <option value="user">Usuário</option>
          <option value="admin">Admin</option>
        </select>
      </div>

      <div className="sm:col-span-2 flex flex-col sm:flex-row gap-2 justify-end">
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 w-full sm:w-auto"
        >
          {userToEdit ? "Atualizar" : "Criar"}
        </button>
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400 w-full sm:w-auto"
          >
            Cancelar
          </button>
        )}
      </div>
    </form>
  );
};

export default UserForm;