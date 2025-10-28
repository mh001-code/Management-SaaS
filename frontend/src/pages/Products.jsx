import React, { useState, useEffect } from "react";
import ProductForm from "../components/ProductForm";
import ProductTable from "../components/ProductTable";
import { getAllProducts, createProduct, updateProduct, deleteProduct } from "../services/productService";

export default function Products() {
  const [products, setProducts] = useState([]);
  const [productToEdit, setProductToEdit] = useState(null);
  const [loading, setLoading] = useState(true);

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

  const handleEdit = (product) => setProductToEdit(product);
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
    <div className="p-6 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6 text-center">Gerenciar Produtos</h1>
      <ProductForm productToEdit={productToEdit} onSave={handleSave} onCancel={handleCancel} />
      {loading ? <div>Carregando...</div> : <ProductTable products={products} onEdit={handleEdit} onDelete={handleDelete} />}
    </div>
  );
}