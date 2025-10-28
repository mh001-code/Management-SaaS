import api from "./api";

// CRUD de produtos
export const getAllProducts = () => api.get("/products");
export const createProduct = (data) => api.post("/products", data);
export const updateProduct = (id, product) => {
+ console.log("🔄 Enviando PUT para /products/" + id, product);
  return api.put(`/products/${id}`, product);
};
export const deleteProduct = (id) => api.delete(`/products/${id}`);
