import React, { useState, useEffect, useRef } from "react";
import ProductForm from "../components/ProductForm";
import ProductTable from "../components/ProductTable";
import { getAllProducts, createProduct, updateProduct, deleteProduct } from "../services/productService";

export default function Products() {
  const [products, setProducts] = useState([]);
  const [productToEdit, setProductToEdit] = useState(null);
  const [loading, setLoading] = useState(true);

  // Referência para o formulário
  const formRef = useRef(null);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      setLoading(true);
      const { data } = await getAllProducts();
      setProducts(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async (product) => {
    try {
      if (productToEdit) {
        await updateProduct(productToEdit.id, product);
      } else {
        await createProduct(product);
      }
      setProductToEdit(null);
      fetchProducts();
    } catch (err) {
      console.error(err);
    }
  };

  const handleEdit = (product) => {
    setProductToEdit(product);

    // Scroll para o topo do formulário
    if (formRef.current) {
      formRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  };

  const handleCancel = () => setProductToEdit(null);

  const handleDelete = async (id) => {
    if (!confirm("Deseja realmente deletar este produto?")) return;
    try {
      await deleteProduct(id);
      fetchProducts();
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="p-4 md:p-6 bg-gray-100 min-h-screen max-w-full md:max-w-6xl mx-auto">
      <h1 className="text-2xl md:text-3xl font-bold mb-6 text-center">
        Gerenciar Produtos
      </h1>

      {/* Adiciona a referência aqui */}
      <div ref={formRef}>
        <ProductForm
          productToEdit={productToEdit}
          onSave={handleSave}
          onCancel={handleCancel}
        />
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-10">
          <div className="w-10 h-10 border-4 border-blue-500 border-dashed rounded-full animate-spin"></div>
        </div>
      ) : (
        <ProductTable
          products={products}
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      )}
    </div>
  );
}